require 'rack'

module Walletone
  class NotifyCallback
    def call(env)
      request  = Rack::Request.new(env)
      params   = encode_params(request.params)
      response = Response.new(params)

      log("Prepared params: #{params}")
      log("#{request.request_method} #{request.query_string}\n" +
          "#{request.body.read}")

      body = Walletone.notify_callback.call(response, env)

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

    def log(message)
      Walletone.logger.info(message)
    end
  end
end
