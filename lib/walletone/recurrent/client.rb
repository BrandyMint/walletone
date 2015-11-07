require 'faraday'

class Walletone::Recurrent::Client
  RECURRENT_API = 'https://wl.walletone.com/checkout/recurrenceapi/'

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
    fail 'Must be a RecurrentInvoice' unless invoice.is_a? Walletone::Recurrent::Invoice

    do_request RECURRENT_API + 'invoices', invoice.to_json
  end

  def make_payment(payment_id)
    body = { CustomerId: customer_id, UseSavedAuthData: 'true', CreditCardTerminal: 'Non3Ds' }.to_json

    do_request RECURRENT_API + "payments/#{payment_id}/process", body
  end

  private

  attr_reader :merchant_id, :customer_id, :secret_key, :hash_type, :timestamp, :hash_type

  def do_request url, body
    f = Faraday.new url
    f.post do |req|
      req.headers['Content-Type'] = 'application/json; charset=utf-8'
      req.headers['X-Wallet-UserId'] = merchant_id
      req.headers['X-Wallet-Timestamp'] = timestamp
      req.headers['X-Wallet-Signature'] = signature body
      req.body = body
    end
  end

  def signature body
    Walletone::Signer.sign [merchant_id, customer_id, timestamp, body, secret_key].join, hash_type
  end
end
