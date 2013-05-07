source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.13'
gem 'mongoid', '~> 3.0.0'
gem 'rails-i18n'
gem "bcrypt-ruby", :require => "bcrypt"
gem 'nokogiri', :require => false
gem 'jquery-rails'
gem 'mongoid_slug'
gem 'kaminari'
gem 'mongoid_fulltext'
gem 'geocoder'
gem 'unicorn'

group :assets do
  gem 'sass-rails'
  gem 'therubyracer', :platforms => :ruby
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
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
  gem 'capybara', '2.0.3'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'simplecov', :require => false
end
