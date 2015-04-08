require 'cgi'
module Walletone
  class Form
    include Virsut.model strict: true
    attribute :fields, Fields, required: true

    def checkour_url
      Walletone.config.web_checkout_url
    end

    def hidden_fields_tags
      fields.to_list do |field|
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
      "<input name=\"#{CGI.escapeHTML(name)}\" type=\"hidden\" value=\"#{CGI.escapeHTML(value)}\" />".html_safe
    end

  end
end
