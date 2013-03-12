require 'simplecov'
SimpleCov.start "rails" if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"

  require 'database_cleaner'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  #config.include SpecHelpers, :example_group => {
  #  :file_path => config.escaped_path(%w[spec (requests|features)])
  #}

  config.include FactoryGirl::Syntax::Methods

  config.include Capybara::DSL
end
