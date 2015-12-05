require 'walletone/fields'

# Уведомление об оплате от walletone которое пришло через rack middleware callback
#

module Walletone
  class Notification < Fields
    FIELDS = %i(
      WMI_AUTO_ACCEPT

      WMI_NOTIFY_COUNT
      WMI_LAST_NOTIFY_DATE

      WMI_MERCHANT_ID

      WMI_RECURRING_PAYMENTS_APPROVED

      WMI_PAYMENT_NO
      WMI_PAYMENT_AMOUNT
      WMI_PAYMENT_TYPE

      WMI_COMMISSION_AMOUNT
      WMI_CURRENCY_ID
      WMI_TO_USER_ID

      WMI_ORDER_ID
      WMI_ORDER_STATE

      WMI_DESCRIPTION
      WMI_SUCCESS_URL WMI_FAIL_URL
      WMI_EXPIRED_DATE
      WMI_CREATE_DATE WMI_UPDATE_DATE

      WMI_RECURRENCE_STATE_ID

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
