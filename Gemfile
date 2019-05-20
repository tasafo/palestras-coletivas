source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2'
gem 'rails-i18n'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'bcrypt', require: 'bcrypt'
gem 'nokogiri', require: false
gem 'multi_json', require: false
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'airbrake', '~> 6.1'
gem 'active_model_serializers'

gem 'mongoid', '~> 7.0'
gem 'mongoid-slug'
gem 'mongoid_search'
gem 'geocoder'

gem 'sprockets'
gem 'popper_js'
gem 'material_components_web-sass'

gem 'uglifier'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'

gem 'sidekiq'
gem 'sinatra', require: false

gem 'puma'

gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'carrierwave-i18n'
gem 'cloudinary', '1.9.1'

gem "serviceworker-rails"

gem 'meta-tags'

gem 'bootsnap'

group :development do
  gem 'web-console'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'bullet'
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'faker'
end

group :test do
  gem 'rspec-mocks'
  gem 'webmock'
  gem 'rake'
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit'
  gem 'selenium-webdriver'
  gem 'simplecov', '0.16.1', require: false
end

group :production do
  gem 'newrelic_rpm'
  gem 'scout_apm'
end
