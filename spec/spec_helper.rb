require 'simplecov'
SimpleCov.start 'rails' if ENV['COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/cuprite'
require 'webmock/rspec'
require 'database_cleaner'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'

  config.include SpecHelpers

  config.include FactoryBot::Syntax::Methods

  config.include Capybara::DSL

  Capybara.default_max_wait_time = 5

  Capybara.register_driver :cuprite do |app|
    Capybara::Cuprite::Driver.new(app, headless: true)
  end

  Capybara.javascript_driver = :cuprite

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid'
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    FileUtils.rm_rf("#{Rails.root}/public/uploads/tmp")
  end

  Mongoid.logger.level = Logger::INFO
end
