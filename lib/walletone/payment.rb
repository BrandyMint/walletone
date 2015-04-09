require 'walletone/fields'
require 'walletone/signer'
require 'base64'
require 'time'

# Поля для формы оплаты формируемые приложением
#
module Walletone
  class Payment < Fields
    RUB_ISO_NUMBER = 643
    DEFAULT_CURRENTY = RUB_ISO_NUMBER

    def sign!(secret_key, hash_type=Signer::DEFAULT_HASH_TYPE)
      raise 'Already signed!' if signed?
      self.WMI_SIGNATURE = signer.signature secret_key, hash_type

      freeze
    end

    def signed?
      self.WMI_SIGNATURE.is_a?(String) && ! self.WMI_SIGNATURE.empty?
    end

    def WMI_CURRENCY_ID
      super || DEFAULT_CURRENTY
    end

    def WMI_PAYMENT_AMOUNT
      value = super
      "%.2f" % value if value
    end

    def WMI_DESCRIPTION
      value = super
      "BASE64:#{Base64.encode64(value[0...250])[0..-2]}" if value
    end

    def WMI_EXPIRED_DATE
      value = super
      value ? value.iso8601 : value
    end

  end
end
