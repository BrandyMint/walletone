# encoding: utf-8
# Сервис для уведомления walleone о том, что нужно начать доставку
# W1::OrderDeliveryService.new(order).create
require 'cgi'
module W1
  class OrderDeliveryService
    def initialize order
      @order = order
    end

    def create
      debug message: "OrderDeliveryService#create", fields: fields.to_s

      response

      info message: "Delivery order", 
        url: uri.to_s, 
        response_code: response.code, 
        response_body: response.body, 
        fields: fields.to_s

      raise W1::OrderDeliveryService::Error.new response unless response.code.to_i == 302

      # Раньше подтверждали только после удачи,
      # теперь сразу
      order.order_delivery.delivery!

      redirect_uri = pull_redirect_uri response.body
      order.order_payment.update_attributes! external_id: pull_w1_order_id( redirect_uri )

      debug message: "Делаю подтверждающий редирект", url: redirect_uri.to_s

      get_response = Net::HTTP.get_response redirect_uri

      if get_response.code.to_i == 302
        debug message: "Подтверждающий редирект - DONE", 
          url: redirect_uri.to_s, 
          response_body: response.body

        # Раньше подтверждали только после удачи
        #order.order_delivery.delivery!
      else
        error message: "Ошибка подтверждающего редиректа", 
          url: redirect_uri.to_s, 
          response_body: response.body, 
          response_code: response.code
      end


      return true

      # в 20-й строке!
      # EOFError: end of file reached>
      # "302"
      # "<html><head><title>Object moved</title></head><body>\r\n<h2>Object moved to <a href=\"https://www.walletone.com/checkout/Default.aspx?i=347508545860&amp;m=127696943127\">here</a>.</h2>\r\n</body></html>\r\n"
    rescue => err
      raise err if Rails.env.test?
      raise err if defined?( VCR ) && err.is_a?( VCR::Errors::UnhandledHTTPRequestError )
      binding.pry if Rails.env.development?
      error message: "Delivery order", error: err.inspect
      Honeybadger.notify err, context: { order_id: order.id }
      return false
    end

    private

    attr_reader :order

    #  <html><head><title>Object moved</title></head><body>
    #  <h2>Object moved to <a href="https://www.walletone.com/checkout/Default.aspx?i=347632112961&amp;m=127696943127">here</a>.</h2>;
    #  </body></html>

    def pull_redirect_uri body
      Addressable::URI.parse Nokogiri::HTML(body).css('body/h2/a').attr('href').value
    rescue
      nil
    end

    def error params
      W1.logger.error params.merge order_id: order.id
    end

    def info params
      W1.logger.info params.merge order_id: order.id
    end

    def debug params
      W1.logger.debug params.merge order_id: order.id
    end

    def response
      @response ||= Net::HTTP.post_form uri, fields
    end

    def pull_w1_order_id uri
      # "https://www.walletone.com/checkout/Default.aspx?i=347632097524&m=127696943127"
      return CGI.parse(uri.query)['i'].first
    rescue => err
      raise err if Rails.env.test?
      err.to_s
    end

    def uri
      @url ||= URI.parse API_CHECKOUT_URL
    end

    def fields
      @fields ||= FormOptions.generate order
    end

  end
end

class W1::OrderDeliveryService::Error < StandardError
  def initialize response
    @response = response
  end
  def message
    "Ошибка отправки запроса: #{@response.code.to_i}"
  end

  def inspect
    "#{@response.code} #{@response.body}"
  end
end

