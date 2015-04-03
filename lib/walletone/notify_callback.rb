require 'rack'

module Walletone
  class NotifyCallback
    def call(env)
      [200, {}, ['Hello Rack!']]
    end
  end
end
