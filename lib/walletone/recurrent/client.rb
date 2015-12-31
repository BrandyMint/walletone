require 'faraday'

module Walletone::Recurrent
  require 'walletone/recurrent/invoice'
  require 'walletone/recurrent/result_invoice'

  class Client
    RECURRENT_API        = 'https://wl.walletone.com/checkout/invoicingapi/'
    INVOICE_CLASS        = Walletone::Recurrent::Invoice
    RESULT_INVOICE_CLASS = Walletone::Recurrent::ResultInvoice

    # @param [merchant_id]
    #
    def initialize(merchant_id:, customer_id:, secret_key:, hash_type: Walletone::Signer::DEFAULT_HASH_TYPE)
      @merchant_id = merchant_id.to_s
      @customer_id = customer_id.to_s
      @secret_key  = secret_key.to_s
      @hash_type   = hash_type
      @timestamp   = Time.now.utc.strftime('%FT%T')
    end

    def create_invoice(invoice)
      fail "Must be a #{INVOICE_CLASS} (#{invoice})" unless invoice.is_a? INVOICE_CLASS

      result = do_request RECURRENT_API + 'invoices', invoice.to_json

      RESULT_INVOICE_CLASS.new result
    end

    def make_payment(payment_id: nil, email: nil)
      body = { CustomerId: customer_id, CreditCardTerminal: 'Non3Ds', UseSavedAuthData: 'true', AuthData: { RecurrentCreditCardEmail: email } }.to_json

      do_request RECURRENT_API + "payments/#{payment_id}/process", body
    end

    private

    attr_reader :merchant_id, :customer_id, :secret_key, :hash_type, :timestamp, :hash_type

    def do_request url, body
      uri = URI.parse url

      req = Net::HTTP::Post.new uri, build_headers(url, body)
      req.body = body

      log "Request [#{uri}]: #{body}"
      http = build_http uri
      response = http.request req
      log "Response [#{uri}] #{body}:\n    [#{response.code}] #{response.body}"
      fail Walletone::ErrorResponse, response if response.is_a? Net::HTTPInternalServerError

      MultiJson.load response.body
    end

    def build_http(uri)
      Net::HTTP.start uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE # OpenSSL::SSL::VERIFY_PEER
    end

    def build_headers(url, body)
      {
        'Content-Type'       => 'application/json; charset=utf-8',
        'X-Wallet-UserId'    => merchant_id,
        'X-Wallet-Timestamp' => timestamp,
        'X-Wallet-Signature' => signature(url, body)
      }
    end

    def log(message)
      Walletone.logger.info "Recurrent::Client: #{message}"
    end

    def signature url, body
      Walletone::Signer.sign [url, merchant_id, timestamp, body, secret_key].join, hash_type
    end
  end
end
