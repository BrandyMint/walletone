require 'walletone/fields'

# Уведомление об оплате от walletone которое пришло через rack middleware callback
#

module Walletone
  class Notification < Fields
    FIELDS = %i(
    WMI_MERCHANT_ID
    WMI_PAYMENT_AMOUNT
    WMI_COMMISSION_AMOUNT
    WMI_CURRENCY_ID
    WMI_TO_USER_ID
    WMI_PAYMENT_NO
    WMI_ORDER_ID
    WMI_DESCRIPTION
    WMI_SUCCESS_URL WMI_FAIL_URL
    WMI_EXPIRED_DATE
    WMI_CREATE_DATE WMI_UPDATE_DATE
    WMI_ORDER_STATE
    WMI_SIGNATURE
    )

    define_fields FIELDS

    def initialize params
      super( params ).freeze
    end

    # Обязательно проверяем валидость уведомления, вдруг его
    # прислал злоумышленник.
    #
    def valid?(secret_key, hash_type = Signer::DEFAULT_HASH_TYPE)
      self.WMI_SIGNATURE == signer.signature( secret_key, hash_type )
    end

    # Принята оплата или не прошла?
    #
    def accepted?
      self['WMI_ORDER_STATE'].to_s.upcase == 'ACCEPTED'
    end

  end
end
