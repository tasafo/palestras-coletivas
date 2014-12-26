source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.0'
gem 'mongoid'
gem 'rails-i18n'
gem 'bcrypt', :require => 'bcrypt'
gem 'nokogiri', :require => false
gem 'multi_json', :require => false
gem 'jquery-rails'
gem 'mongoid-slug'
gem 'kaminari'
gem 'mongoid_search', github: 'mauriciozaffari/mongoid_search', branch: 'master'
gem 'geocoder'
gem 'unicorn'
gem 'lograge'
gem 'newrelic_rpm'

gem 'sass-rails'
gem 'bootstrap-sass'
gem 'therubyracer', :platforms => :ruby
gem 'uglifier'

group :development do
  gem 'web-console'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'dotenv-rails'
end

group :test do
  gem 'rake'
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'simplecov', :require => false
  gem "codeclimate-test-reporter", require: nil
end

group :production do
  gem 'rails_12factor'
end