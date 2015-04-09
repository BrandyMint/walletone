# Базовый класс для полей формы и уведомления
#
module Walletone
  class Fields < Hash
    # http://www.walletone.com/ru/merchant/documentation/#step2
    #
    #
    W1_KEYS = %i(
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

    MULTIPLE_VALUES = %i(WMI_PTENABLED WMI_PTDISABLED)

    # Определяем методы для прямого доступа
    # > payment.WMI_MERCHANT_ID
    # > payment.WMI_MERCHANT_ID=123
    #
    # > payment.WMI_PTENABLED = 
    W1_KEYS.each do |k|
      define_method k do
        fetch k
      end

      define_method "#{k}=" do |value|
        self[k]= value
      end
    end

    def initialize attrs={}
      fields = super
      return fields if attrs.empty?
      symbolyzed_attrs = attrs.inject({}) { |acc, e| acc[e.first.to_sym]=e.last; acc }
      fields.merge! symbolyzed_attrs
    end

    def [] key
      fetch key.to_sym, nil
    end

    def []= key, value
      super key.to_sym, value
    end

    def fetch key, default=nil
      super key.to_sym, default
    end

    def as_list
      keys.inject([]) do |acc, name|
        # Делаем именно так, чтобы работало переопределение методов
        # в Payment
        value = respond_to?(name) ? send(name) : fetch(name)
        Array(value).each { |v| acc << [name.to_s, v.to_s] }
        acc
      end
    end

    private

    def signer
      Signer.new fields: self
    end

  end
end
