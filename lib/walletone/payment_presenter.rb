require 'delegate'
require 'base64'
require 'time'

module Walletone
  class PaymentPresenter < SimpleDelegator
    def WMI_PAYMENT_AMOUNT
      "%.2f" % super if super
    end

    def WMI_DESCRIPTION
      "BASE64:#{Base64.encode64(super[0...250])[0..-2]}" if super
    end

    def WMI_EXPIRED_DATE
      super.iso8601 if super
    end
  end
end
