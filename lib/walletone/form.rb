require 'cgi'
module Walletone
  class Form
    include Virtus.model strict: true, coerce: false
    attribute :payment, Payment, required: true

    def checkout_url
      Walletone.config.web_checkout_url
    end

    def hidden_fields_tags
      payment.as_list.map do |field|
        key, value = field
        hidden_field_tag(key, value)
      end.join
    end

    # Рекомендуемые опции
    def options
      { authenticity_token: false, enforce_utf8: false }
    end

    private

    def hidden_field_tag name, value
      "<input name=\"#{CGI.escapeHTML(name.to_s)}\" type=\"hidden\" value=\"#{CGI.escapeHTML(value.to_s)}\" />"
    end

  end
end
