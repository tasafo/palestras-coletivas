source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.1'
gem 'mongoid'
gem 'rails-i18n'
gem 'bcrypt', require: 'bcrypt'
gem 'nokogiri', require: false
gem 'multi_json', require: false
gem 'mongoid-slug'
gem 'kaminari'
gem 'mongoid_search', github: 'mauriciozaffari/mongoid_search', branch: 'master'
gem 'geocoder'
gem 'dotenv-rails'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'uglifier'
gem 'jquery-rails'
gem 'font-awesome-rails'

group :development do
  gem 'thin'
  gem 'web-console'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'spring'
  gem 'lograge'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :test do
  gem 'rspec-mocks'
  gem 'webmock'
  gem 'rake'
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-webkit', '1.5.0'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem "codeclimate-test-reporter", require: nil
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'newrelic_rpm'
end
