module Walletone
  class Response
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def valid?(signature, secret, hash_type = :md5)
      signer = Signer.new(@params, hash_type)
      signer.sign(secret) == signature
    end

    def param(name)
      @params.select { |k, v| k == name.to_s }.map(&:last)
    end

    def ok(message = nil)
      make_response('OK', message)
    end

    def retry(message = nil)
      make_response('RETRY', message)
    end

  private

    def make_response(result, description)
      if description
        "WMI_RESULT=#{result}&WMI_DESCRIPTION=#{description}"
      else
        "WMI_RESULT=#{result}"
      end
    end
  end
end
