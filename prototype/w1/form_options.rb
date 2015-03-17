module W1
  # http://www.walletone.com/ru/merchant/documentation/
  class FormOptions
    include Rails.application.routes.url_helpers

    attr_accessor :order
    delegate :vendor, :to => :order

    def self.generate order
      self.new(order).generate
    end

    def initialize order
      raise 'Объект не является заказом' unless order.is_a? Order
      @order = order
    end

    def generate
      @list = []

      fill_fields
      # В конце
      add_signature

      @list
    end

    private

    def fill_fields
      # WMI_EXPIRED_DATE
      # WMI_CUSTOMER_FIRSTNAME
      #WMI_CUSTOMER_LASTNAME
      #WMI_CUSTOMER_EMAIL
      add_order_id
      add_merchant_id
      add_payment_amount
      add_description
      add_currency
      add_return_urls
      add_payment_methods
      add_email if order.email.present?
      add_delivery if order.payment_type.auto_delivery? && order.delivery_type.is_a?(OrderDeliveryRedexpress)
    end

    def add_order_id
      add WMI_PAYMENT_NO, order.wmi_payment_no
    end

    def add_merchant_id
      add 'WMI_MERCHANT_ID',  vendor.w1_merchant_id
    end

    def add_payment_amount
      add 'WMI_PAYMENT_AMOUNT',  order.total_with_delivery_price.to_s #calculate_amount
    end

    def add_description
      add 'WMI_DESCRIPTION',  payment_description
    end

    def add_currency
      add 'WMI_CURRENCY_ID',  order.currency.iso_numeric
    end

    def add_return_urls
      add 'WMI_SUCCESS_URL',  success_vendor_payments_w1_url(:domain => vendor.domain)
      add 'WMI_FAIL_URL',  failure_vendor_payments_w1_url(:domain => vendor.domain)
    end

    def add_signature
      add WMI_SIGNATURE, signature
    end

    def add_email
      add 'WMI_CUSTOMER_EMAIL',  order.email
    end

    # Доступные способы оплаты
    # http://www.walletone.com/ru/merchant/documentation/#step4
    def add_payment_methods
      if (list = order.payment_type.wmi_enabled_payment_methods).present?
        add 'WMI_PTENABLED',  list
      end
      if (list = order.payment_type.wmi_disabled_payment_methods).present?
        add 'WMI_PTDISABLED',  list
      end
    end

    def add_delivery
      add 'WMI_DELIVERY_REQUEST',         1
      add 'WMI_DELIVERY_COUNTRY',         order.country
      add 'WMI_DELIVERY_CITY',            order.city_title.squish
      add 'WMI_DELIVERY_ADDRESS',         order.address.squish
      add 'WMI_DELIVERY_CONTACTINFO',     order.phone
      add 'WMI_DELIVERY_COMMENTS',        delivery_comments
      add 'WMI_DELIVERY_ORDERID',         order.wmi_payment_no

      # нужно этим магазинам прописать данную инф, тогда автомаически все заказы будут идти как подтвержденные
      add 'WMI_DELIVERY_SKIPINSTRUCTION',  1
    end

    def delivery_comments
      if Rails.env.production?
        order.comment
      else
        'ТЕСТОВЫЙ ЗАКАЗ. НЕ ВЫПОЛНЯТЬ!'
      end
    end

    def add key, value
      @list.push [key, value]
    end

    def signature
      W1.generate_signtature_from_list( @list, vendor.w1_md5_secret_key )
    end

    def payment_description
      buffer = Rails.env.production? ? '' : "Тестовый платеж! "
      buffer << order.description
      buffer.truncate(250)
      # encoded_desc = Base64.urlsafe_encode64(desc)
      # "BASE64:#{encoded_desc}"
    end

    #def calculate_amount
      #if order.payment_type.w1_payment_id == 'CreditCardRUB'
        #price = order.total_with_delivery_price.to_f
        #new_price = ((price*price)/(price*0.02 + price)).round(2)
        #new_price.to_s
      #else
        #order.total_with_delivery_price.to_s
      #end
    #end
  end
end
