require 'walletone/fields'
# Уведомление от walletone которое пришло через rack middleware callback
#

module Walletone
  class Notification < Fields

    def initialize params
      super( params ).freeze
    end

    def valid?(secret_key, hash_type = Signer::DEFAULT_HASH_TYPE)
      self.WMI_SIGNATURE == signer.signature( secret_key, hash_type )
    end

  end
end
