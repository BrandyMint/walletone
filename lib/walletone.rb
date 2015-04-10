require 'logger'
require 'virtus'

require 'walletone/payment'
require 'walletone/notification'
require 'walletone/form'
require 'walletone/middleware/base'

module Walletone
  API_URL          = 'https://api.w1.ru/OpenApi/'
  V1_CHECKOUT_URL = 'https://www.walletone.com/checkout/default.aspx'
  V2_CHECKOUT_URL = 'https://wl.walletone.com/checkout/checkout/Index'

  class Configuration
    include ::Singleton
    attr_accessor :logger, :error_notifier, :error_notify_method, :web_checkout_url

    def self.default_logger
      logger = Logger.new(STDOUT)
      logger.progname = 'walletone'
      logger
    end

    def initialize
      self.logger = self.class.default_logger
      self.web_checkout_url = V2_CHECKOUT_URL
      self.error_notify_method = :notify
      self.error_notifier = Honeybadger if defined? Honeybadger
      self.error_notifier = Bugsnag if defined? Bugsnag
    end
  end

  def self.notify_error error, *args
    logger.error "Catch error #{error}"
    return unless config.error_notifier
    config.error_notifier.send self.config.error_notify_method, error, *args
  end

  def self.raise_error error
    notify_error error
    fail error
  end

  def self.config
    Configuration.instance
  end

  def self.configure
    yield config
  end

  def self.logger
    config.logger
  end
end
