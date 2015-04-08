require 'rack'

module Walletone
  class NotifyCallback
    def call(env)
      request  = Rack::Request.new(env)
      params   = encode_params(request.params)
      response = Response.new(params)

      Walletone.log(:info, "Prepared params: #{params}")
      Walletone.log(:info, "#{request.request_method} #{request.query_string}\n" +
        "#{request.body.read}")

      body = Walletone.notify_callback.call(response, env)

      Walletone.log(:info, "Respond with #{body}")

      [status, headers, [body]]
    end

  private

    def status
      200
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
