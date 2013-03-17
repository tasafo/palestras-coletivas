source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.12'
gem 'mongoid', '~> 3.0.0'
gem 'rails-i18n'
gem "bcrypt-ruby", :require => "bcrypt"
gem 'nokogiri', :require => false
gem 'jquery-rails'
gem 'simple_form'

group :assets do
  gem 'sass-rails'
  gem 'therubyracer', :platforms => :ruby
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
  gem 'uglifier'
end

group :development, :test do
  gem 'thin'
  gem 'pry'
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :test do
  gem 'capybara'
  gem 'simplecov', :require => false
end