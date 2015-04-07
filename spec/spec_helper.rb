require 'walletone'
require 'fabrication'
require 'ffaker'

RSpec.configure do |config|
  config.order = :random

  config.before(:all) do
    Walletone.logger.level = Logger::FATAL
  end
end
