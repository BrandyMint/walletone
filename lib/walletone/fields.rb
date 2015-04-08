require 'walletone/signer'
# Базовый класс для полей формы и уведомления
#
module Walletone
  class Fields < Hash
    # http://www.walletone.com/ru/merchant/documentation/#step2
    #
    #
    W1_KEYS = %(
        WMI_MERCHANT_ID
        WMI_PAYMENT_AMOUNT
        WMI_CURRENCY_ID
        WMI_PAYMENT_NO
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

    MULTIPLE_VALUES = %(WMI_PTENABLED WMI_PTDISABLED)

    # Определяем методы для прямого доступа
    # > payment.WMI_MERCHANT_ID
    # > payment.WMI_MERCHANT_ID=123
    #
    # > payment.WMI_PTENABLED = 
    W1_KEYS.each do |k|
      define_method k do
        self[k]
      end

      define_method k+'=' do |value|
        self[k]= value
      end
    end

    def as_list
      map.inject([]) do |acc, kv|
        name, value = kv

        if value.is_a?(Array)
          value.each do |k, v|
            acc << [k.to_s, v]
          end
        else
          acc << [name.to_s, value]
        end
      end
    end

    private

    def signer
      @signer ||= Signer.new fields: self
    end


  end
end
