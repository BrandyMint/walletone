require 'rack'

module Walletone
  class NotifyCallback
    # should we check required fields:
    #   WMI_SIGNATURE, WMI_PAYMENT_NO, WMI_ORDER_STATE
    # for existence and automatically respond with RETRY
    # or allow the gem user to do it?
    # and I have same question for WMI_SIGNATURE checking
    def call(env)
      request  = Rack::Request.new(env)
      response = Response.new(encode_params(request.params))
      body     = Walletone.notify_callback.call(response)

      [status, headers, [body]]
    end

  private

    def status
      200 # maybe 201 or 202?
    end

    def headers
      {}
    end

    def encode_params(params)
      params.map do |k, v|
        [k, v.force_encoding("cp1251").encode("utf-8", undef: :replace)]
      end
    end
  end
end
