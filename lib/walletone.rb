require 'logger'
require 'virtus'

require 'walletone/errors/walletone_error'
require 'walletone/errors/bad_url_error'
require 'walletone/tuple'

require 'walletone/signer'
require 'walletone/signed_payment'
require 'walletone/payment'
require 'walletone/payment_presenter'
require 'walletone/response_validator'
require 'walletone/notify_callback'

module Walletone
  API_URL          = 'https://api.w1.ru/OpenApi/'
  WEB_CHECKOUT_URL = 'https://wl.walletone.com/checkout/checkout/Index'
  API_CHECKOUT_URL = 'https://www.walletone.com/checkout/default.aspx'

  class << self
    attr_accessor :logger
    attr_accessor :success_callback, :failed_callback, :invalid_callback
  end

  self.logger = Logger.new(STDERR)
end
