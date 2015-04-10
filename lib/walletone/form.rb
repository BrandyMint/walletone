require 'cgi'
require 'walletone/payment'
module Walletone
  class Form
    attr_reader :payment

    def initialize payment
      unless payment.is_a?( Walletone::Payment ) && payment.valid? && payment.signed?
        Walletone.raise_error ArgumentError.new("Must be valid and signed Payment #{payment}")
      end
      @payment = payment
    end

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
