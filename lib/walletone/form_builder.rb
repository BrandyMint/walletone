require 'base64'
require 'digest/sha1'
require 'digest/md5'
require 'uri'

module Walletone
  class FormBuilder
    attr_reader :fields

    def initialize(fields = [])
      @fields = []

      fields.each do |name, value|
        add_field(name, value)
      end
    end

    def add_field(name, value)
      @fields << [name.to_s, validate(name, value)]
    end

    def add_or_replace_field(name, value)
      @fields.reject! { |o| o.first == name }
      add_field(name, value)
    end

    def get_field(name)
      @fields.select { |o| o.first == name.to_s }
        .map(&:last)
    end

    def generate_signature(secret_key, hash_type = :md5)
      values = @fields
        .reject { |k, v| k == 'wmi_signature' }
        .sort { |x, y| x.first <=> y.first }
        .map(&:last).map(&:to_s)
      signature_string = [values, secret_key].flatten.join
      encoded_signature_string = signature_string.encode('cp1251')

      signature = case hash_type
      when :md5
        Digest::MD5.base64digest(encoded_signature_string)
      when :sha1
        Digest::SHA1.base64digest(encoded_signature_string)
      else
        raise ArgumentError
      end

      add_or_replace_field('wmi_signature', signature)
    end

    def build
      @fields.map do |k, v|
        [k.upcase, v]
      end
    end

  private

    def validate(field_name, value)
      validator = "validate_#{field_name}".to_sym

      if respond_to?(validator, true)
        send(validator, value)
      else
        value
      end
    end

    def validate_wmi_payment_amount(cost)
      "%.2f" % cost
    end

    def validate_wmi_description(text)
      "BASE64:#{Base64.encode64(text[0...250])[0..-2]}"
    end

    def validate_wmi_success_url(url)
      if url =~ URI::regexp
        url
      else
        raise WrongUrlException
      end
    end

    def validate_wmi_fail_url(url)
      if url =~ URI::regexp
        url
      else
        raise WrongUrlException
      end
    end
  end
end
