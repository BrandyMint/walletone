module W1
  class PaymentService
    attr_reader :response

    def initialize vendor: nil, params: nil
      @vendor = vendor
      @params = params
    end

    def perform_and_get_response
      raise InvalidPayment unless payment.valid?

      if payment.accepted?
        return success_payment
      else
        return failed_payment
      end

    rescue => err
      error_catched err
    end

    private

    attr_reader :vendor, :params

    def error_catched err
      W1.error message: 'Ошибка проведения платежа', 
        error: err.to_s, 
        vendor_id: vendor.id,  
        payment: payment.to_s

      Honeybadger.notify err, context: { payment: payment, vendor_id: vendor.id }

      return retry_response("Внутренняя ошибка #{err}")
    end

    def success_payment
      W1.info message: "[order_id=#{payment.order}] Получен платеж заказа.",
        vendor_id: vendor.id,
        payment:   payment.to_s

      payment.order.payment_success! payment
      return success_response
    end

    def failed_payment
      W1.error message: "[order_id=#{payment.order}] Платеж не принят",
        vendor_id: vendor.id,
        payment:   payment.to_s

      payment.order.payment_failure! payment if payment.order.present?

      return retry_response("Платеж не валидный или не полный")
    end

    def success_response
      "WMI_RESULT=OK"
    end

    def retry_response(message)
      "WMI_RESULT=RETRY&WMI_DESCRIPTION=#{CGI.escape(message)}"
    end

    def payment
      @payment ||= W1::PaymentService::Notify.new params, vendor
    end

  end

  class InvalidPayment < StandardError;
    def message
      'Не валидный платеж'
    end
  end
end
