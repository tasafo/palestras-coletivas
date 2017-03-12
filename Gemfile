source 'https://rubygems.org'

ruby '2.3.3'

gem 'rails' , '~> 4.2'
gem 'rails-i18n'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'bcrypt', require: 'bcrypt'
gem 'nokogiri', require: false
gem 'multi_json', require: false
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'airbrake', '4.3.4'
gem 'jbuilder'

gem 'mongoid'
gem 'mongoid-slug'
gem 'mongoid_search'
gem 'geocoder'

gem 'sprockets'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'uglifier'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'

gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

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
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter'
end

group :production do
  gem 'unicorn'
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end
