if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-console'

  SimpleCov.start 'rails'
  SimpleCov.command_name 'specs' + (ENV['TEST_ENV_NUMBER'] || '')
  SimpleCov.merge_timeout 1800

  if ENV['TEST_ENV_NUMBER'] # parallel specs
    SimpleCov.at_exit do
      result = SimpleCov.result
      result.format! if ParallelTests.number_of_running_processes <= 1
    end
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/cuprite'
require 'webmock/rspec'
require 'database_cleaner-mongoid'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.infer_base_class_for_anonymous_controllers = false

  config.order = :random

  config.include SpecHelpers

  config.include FactoryBot::Syntax::Methods

  config.include Capybara::DSL

  Capybara.default_max_wait_time = 5

  Capybara.register_driver :cuprite do |app|
    Capybara::Cuprite::Driver.new(app, headless: true)
  end

  Capybara.javascript_driver = :cuprite

  Capybara.server = :puma, { Silent: true }

  Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i

  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].clean
  end

  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join('public', 'uploads', 'tmp'))
  end

  Mongoid.logger.level = Logger::INFO
end
