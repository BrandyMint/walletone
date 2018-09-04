require 'walletone'
require 'fabrication'
require 'ffaker'
require 'pry'
require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = :random

  config.before(:all) do
    Walletone.logger.level = Logger::FATAL
  end
end
