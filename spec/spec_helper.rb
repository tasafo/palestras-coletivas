require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.start "rails" if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'webmock/rspec'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"

  config.include SpecHelpers

  config.include FactoryGirl::Syntax::Methods

  config.include Capybara::DSL

  #Capybara.javascript_driver = :webkit_debug
  Capybara.javascript_driver = :webkit

  config.before(:each, js: true) do
    page.driver.block_unknown_urls if webkit?
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  Mongoid.logger.level = Logger::INFO
end
