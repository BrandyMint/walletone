module Walletone::Middleware
  class Callback
    include Virtus.model strict: true
    attribute :callback, Proc, required: true

    private

    def perform notify, env
      callback.call notify, env
    end

  end
end

