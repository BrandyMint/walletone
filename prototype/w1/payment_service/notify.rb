# Пример данных
# https://www.honeybadger.io/projects/39607/faults/9648411#notice-summary
# https://www.honeybadger.io/projects/39607/faults/10120189#notice-summary
module W1
  class PaymentService::Notify
    attr_accessor :params, :vendor

    ORDER_ACCEPTED = 'Accepted'

    def initialize params, vendor
      @params = params
      @vendor     = vendor
    end

    def valid?
      order.present? && valid_signature?
    end

    def accepted?
      state.present? && state == ORDER_ACCEPTED
    end

    def order
      @order ||= vendor.orders.find_by_wmi_payment_no payment_no
    end

    def inspect
      params.to_hash
    end

    def to_s
      inspect.to_s
    end

    private

    def signature
      params[WMI_SIGNATURE]
    end

    def state
      params[WMI_ORDER_STATE]
    end

    def payment_no
      params[WMI_PAYMENT_NO]
    end

    def calculated_signature
      W1.generate_signtature_from_options params, vendor.w1_md5_secret_key
    end

    def valid_signature?
      signature.present? && signature == calculated_signature
    end

  end
end
