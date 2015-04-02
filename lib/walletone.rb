require 'logger'
require 'virtus'

require 'walletone/errors/walletone_error'
require 'walletone/errors/bad_url_error'
require 'walletone/payment'
require 'walletone/form_builder'
require 'walletone/form'
require 'walletone/response_validator'

module Walletone
  API_URL          = 'https://api.w1.ru/OpenApi/'
  WEB_CHECKOUT_URL = 'https://wl.walletone.com/checkout/checkout/Index'
  API_CHECKOUT_URL = 'https://www.walletone.com/checkout/default.aspx'

  class << self
    attr_accessor :logger
  end

  self.logger = Logger.new(STDERR)
end
