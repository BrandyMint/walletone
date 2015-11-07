module Walletone
  class ErrorResponse < StandardError
    def initialize(response)
      fail 'Must be a Net::HTTPInternalServerError' unless response.is_a? Net::HTTPInternalServerError
      @response = response
    end

    def message
      "[#{response.code}] #{response.body}"
    end

    private

    attr_reader :response
  end
end
