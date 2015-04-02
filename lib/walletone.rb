require 'logger'

require 'walletone/errors'
require 'walletone/form_builder'
require 'walletone/response_validator'

module Walletone
  API_URL          = 'https://api.w1.ru/OpenApi/'
  WEB_CHECKOUT_URL = 'https://wl.walletone.com/checkout/checkout/Index'
  API_CHECKOUT_URL = 'https://www.walletone.com/checkout/default.aspx'

  # mattr_accessor :logger
  # self.logger = Logger.new(STDERR)
end
