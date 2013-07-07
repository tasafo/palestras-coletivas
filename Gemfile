source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.13'
gem 'mongoid', '~> 3.0.0'
gem 'rails-i18n'
gem "bcrypt-ruby", :require => "bcrypt"
gem 'nokogiri', :require => false
gem 'multi_json', :require => false
gem 'jquery-rails'
gem 'mongoid_slug'
gem 'kaminari'
gem 'mongoid_fulltext'
gem 'geocoder'
gem 'unicorn'
gem 'newrelic_rpm'

group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :test do
  gem 'launchy'
  gem 'capybara', '2.0.3'
  gem 'capybara-webkit', '0.14.2'
  gem 'selenium-webdriver'
  gem 'simplecov', :require => false
end
