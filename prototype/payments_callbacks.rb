class SystemAPI::PaymentsCallbacks < Grape::API
  helpers do
    def prepared_params
      @prepared_params ||= params.except(:route_info).each_pair do |k,v|
        v = v.force_encoding("cp1251").encode("utf-8", undef: :replace)
      end.except :vendor_id, 'vendor_id'
    end

    def vendor
      @vendor ||= Vendor.find(params[:vendor_id])
    end

    def logging message
      W1.logger.info message: message,
        vendor_id: vendor.id, 
        tags: W1
    end
  end

  resource :callbacks do
    params do
      requires :vendor_id, type: Integer
    end
    namespace 'w1/payments/:vendor_id/' do
      format :json
      content_type :txt, 'text/plain'
      desc 'W1 Payment notify callback'
      params do
        optional "WMI_AUTO_ACCEPT", type: String
        optional "WMI_COMMISSION_AMOUNT", type: String
        optional "WMI_CREATE_DATE", type: String
        optional "WMI_CURRENCY_ID", type: String
        optional "WMI_DELIVERY_ADDRESS", type: String
        optional "WMI_DELIVERY_CITY", type: String
        optional "WMI_DELIVERY_COMMENTS", type: String
        optional "WMI_DELIVERY_CONTACTINFO", type: String
        optional "WMI_DELIVERY_COST", type: String
        optional "WMI_DELIVERY_COUNTRY", type: String
        optional "WMI_DELIVERY_DATEFINISHED", type: String
        optional "WMI_DELIVERY_ORDERID", type: String
        optional "WMI_DELIVERY_REQUIRED", type: String
        optional "WMI_DELIVERY_SKIPINSTRUCTION", type: String
        optional "WMI_DELIVERY_STATE", type: String
        optional "WMI_DESCRIPTION", type: String
        optional "WMI_EXPIRED_DATE", type: String
        optional "WMI_EXTERNAL_ACCOUNT_ID", type: String
        optional "WMI_FAIL_URL", type: String
        optional "WMI_LAST_NOTIFY_DATE", type: String
        optional "WMI_MERCHANT_ID", type: String
        optional "WMI_NOTIFY_COUNT", type: String
        optional "WMI_ORDER_ID", type: String
        optional "WMI_ORDER_STATE", type: String
        optional "WMI_PAYMENT_AMOUNT", type: String
        optional "WMI_PAYMENT_NO", type: String
        optional "WMI_PAYMENT_TYPE", type: String
        optional "WMI_SUCCESS_URL", type: String
        optional "WMI_UPDATE_DATE", type: String
        optional "WMI_SIGNATURE", type: String
      end
      before do
        # Пример переданных параметров:
        # https://www.honeybadger.io/projects/39607/faults/9616462#notice-context
        logging "Prepared params: #{prepared_params.to_hash.to_s}"
        logging "#{request.request_method} #{request.query_string}\n#{request.body.read}"
      end
      post :notify do
        content_type 'text/plain'

        W1::PaymentService.
          new(vendor: vendor, params: prepared_params).
          perform_and_get_response
      end
    end
  end
end
