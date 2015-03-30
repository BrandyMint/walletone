# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'spec_helper'
# require 'simplecov'
# require 'simplecov-rcov'
# SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
# SimpleCov.start 'rails'

require 'rails_helper'
require 'rspec/rails'
require 'capybara-screenshot/rspec'
require 'email_spec'
require 'vcr'
require 'chewy/rspec'
require 'pry'
# require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    c.hook_into :webmock
    c.ignore_hosts 'codeclimate.com'
    c.ignore_hosts '127.0.0.1', 'localhost'
  end

  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/

  config.include ChewySupport
  config.include MoneyHelper, type: :feature
  config.include MoneyRails::ActionViewExtension, type: :feature

  config.include(ViewSpecHelper, type: :view)
  config.before(:each, type: :view) { initialize_view_helpers(view) }
  config.include(ViewSpecHelper, type: :controller)
  config.before(:each, type: :controller) { initialize_view_helpers(controller) }
  config.include(ViewSpecHelper, type: :helper)
  config.before(:each, type: :helper) { initialize_view_helpers(helper) }

  config.before(:suite) do
    Chewy.strategy(:bypass)
  end

  config.before :each do
    stub_request :any,  'http://elastic:99999/kiiosk_dev_goods'
  end

  # sql logging
  # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
  # config.before do
  # stub_request(:any, /#{Regexp.quote(URI.parse(W1::API_URL).host)}/).to_rack(W1ApiMock.new)
  # end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.fail_fast = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!
  # config.include RSpec::Rails::RequestExampleGroup, type: :request, example_group: {
  # file_path: /spec\/api/
  # }
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.include(ElasticMock)
end
