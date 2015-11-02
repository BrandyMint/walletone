require 'walletone/fields'
require 'walletone/signer'
require 'base64'
require 'time'

# Поля для формы оплаты формируемые приложением
#
module Walletone
  class Payment < Fields
    # http://www.walletone.com/ru/merchant/documentation/#step2
    #
    #
    class << self
      attr_accessor :encode_description
    end

    DESCRIPTION_TRUNCATE_LENGTH = 250
    FIELDS = %i(
        WMI_MERCHANT_ID
        WMI_PAYMENT_NO
        WMI_PAYMENT_AMOUNT
        WMI_CURRENCY_ID
        WMI_DESCRIPTION
        WMI_SUCCESS_URL WMI_FAIL_URL
        WMI_EXPIRED_DATE
        WMI_PTENABLED WMI_PTDISABLED
        WMI_RECIPIENT_LOGIN
        WMI_CUSTOMER_FIRSTNAME WMI_CUSTOMER_LASTNAME WMI_CUSTOMER_EMAIL
        WMI_CULTURE_ID
        WMI_SIGNATURE
        WMI_DELIVERY_REQUEST
        WMI_DELIVERY_COUNTRY WMI_DELIVERY_REGION WMI_DELIVERY_CITY WMI_DELIVERY_ADDRESS
        WMI_DELIVERY_CONTACTINFO WMI_DELIVERY_COMMENTS WMI_DELIVERY_ORDERID
        WMI_DELIVERY_DATEFROM WMI_DELIVERY_DATETILL
        WMI_PSP_MERCHANT_ID
    )

    MULTIPLE_VALUES = %i(WMI_PTENABLED WMI_PTDISABLED)

    RUB_ISO_NUMBER = 643
    DEFAULT_CURRENTY = RUB_ISO_NUMBER

    define_fields FIELDS

    def sign!(secret_key, hash_type=Signer::DEFAULT_HASH_TYPE)
      raise 'Already signed!' if signed?
      self.WMI_SIGNATURE = signer.signature secret_key, hash_type

      freeze
    end

    def signed?
      self.WMI_SIGNATURE.is_a?(String) && ! self.WMI_SIGNATURE.empty?
    end

    def valid?
      # Где узнать какие поля обязательные?
      self.WMI_PAYMENT_AMOUNT && self.WMI_MERCHANT_ID
    end

    # Form generation shortcut
    def form
      Walletone::Form.new self
    end

    def WMI_CURRENCY_ID
      fetch(:WMI_CURRENCY_ID) || DEFAULT_CURRENTY
    end

    def WMI_PAYMENT_AMOUNT
      value = fetch :WMI_PAYMENT_AMOUNT
      "%.2f" % value if value
    end

    def WMI_DESCRIPTION
      value = fetch :WMI_DESCRIPTION
      return value unless value
      if self.class.encode_description
        # TODO энкодить автоматически, если встречаются национальные символы
        "BASE64:#{Base64.encode64(value[0...250])[0..-2]}"
      else
        value.slice 0, DESCRIPTION_TRUNCATE_LENGTH
      end
    end

    def WMI_EXPIRED_DATE
      value = fetch :WMI_EXPIRED_DATE
      value ? value.iso8601 : value
    end
  end
end
