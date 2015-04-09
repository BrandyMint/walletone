module Walletone::Middleware
  class Callback < Base

    def initialize callback
      raise 'Callback must be a Proc' unless callback.is_a? Proc
      @callback = callback
      super()
    end

    private

    attr_reader :callback

    def perform notify, env
      callback.call notify, env
    end

  end
end
