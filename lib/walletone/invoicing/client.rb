require 'money'
require 'multi_json'

# https://docs.google.com/document/d/18YaYbAwHo5jKCx88ox3okj1RJqcPF_2gSDdzpK2XHDI/pub?embedded=true#h.m24dtbijqng
#
module Walletone::Invoicing
  class Client
    CABINET_ID      = 'checkout' # yessplaycheckout
    REQUEST_TIMEOUT = 1
    OPERATORS       =  %w(MtsRUB MegafonRUB Tele2RUB BeelineRUB)

    BASE_URL = "https://wl.walletone.com/#{CABINET_ID}/invoicingapi/"

    def initialize(user_id:, secret_key:, hash_type: Walletone::Signer::DEFAULT_HASH_TYPE)
      @user_id    = user_id or fail 'no user_id'
      @user_id    = @user_id.to_s
      @secret_key = secret_key or fail 'no secret_key'
      @hash_type  = hash_type or fail 'no hash_type'
      @timestamp  = Time.now.utc.strftime('%FT%T')
    end

    def do_phone_payment(amount:, order_id:, phone: ,additional_params:)
      invoice = make_invoice(amount: amount, order_id: order_id, additional_params: additional_params)
      result = make_payments_process payment_id: invoice['Invoice']['Payment']['PaymentId'], phone: phone
    end

    def make_payments_process(payment_id:, customer_id: nil, phone:)
      fail 'must be payment_id' unless payment_id
      fail 'must be phone' unless phone
      body = {
        'AuthData'     => { 'MobileCommercePhoneNumber' => phone }
        # 'SaveAuthData' => false,
      }
      body['CustomerId'] = customer_id.to_s if customer_id
      make_request "payments/#{payment_id}/process", body.to_json
    end

    #  MtsRUB, MegafonRUB, Tele2RUB, BeelineRUB
    def make_invoice(amount:, order_id:, payment_type_id: 'MtsRUB', additional_params: {})
      fail 'amount must be a Money' unless amount.is_a?(Money)
      fail 'order_id must be' unless order_id

      body = {
        'OrderId'       => order_id.to_s,
        'Amount'        => amount.to_f,
        'CurrencyId'    => amount.currency.iso_numeric.to_i,
        'PaymentTypeId' => payment_type_id
      }

      body['InvoiceAdditionalParams'] = additional_params if additional_params.is_a?(Hash) && !additional_params.empty?

      make_request 'invoices', body.to_json
    end

    private

    attr_reader :user_id, :secret_key, :timestamp, :hash_type

    def make_request(path, body)
      uri = URI.parse BASE_URL + path

      headers = build_headers(uri.to_s, body)

      req = Net::HTTP::Post.new uri, headers
      req.body = body

      log "Request [#{uri}]: #{body}"
      http = build_http uri
      response = http.request req
      log "Response [#{uri}] #{body}: [#{response.code}] #{response.body}"
      fail Walletone::ErrorResponse, response if response.is_a? Net::HTTPInternalServerError

      MultiJson.load response.body
    end

    def build_http(uri)
      Net::HTTP.start uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE # OpenSSL::SSL::VERIFY_PEER
    end

    def signature url, body
      Walletone::Signer.sign [url, user_id, timestamp, body, secret_key].join, hash_type
    end

    def log(message)
      Walletone.logger.info "InvoicingAPI: #{message}"
    end

    def build_headers(url, body)
      {
        'Content-Type'       => 'application/json; charset=utf-8',
        'X-Wallet-Timestamp' => timestamp,
        'X-Wallet-UserId'    => user_id,
        'X-Wallet-Signature' => signature(url, body)
      }
    end
  end
end
