source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby RUBY_VERSION

gem 'rails', '~> 6.1'
gem 'rails-i18n', '~> 6.0'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'bcrypt', require: 'bcrypt'
gem 'nokogiri', require: false
gem 'multi_json', require: false
gem 'pagy'
gem 'jsonapi-rails'

gem 'mongoid', '7.3.3'
gem 'mongoid-slug'
gem 'mongo_beautiful_logger'

gem 'geocoder'

gem 'serviceworker-rails'

gem 'tinymce-rails'
gem 'tinymce-rails-langs'

gem 'webpacker'

gem 'sidekiq'
gem 'sinatra', require: false

gem 'puma'

gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'carrierwave-i18n'
gem 'cloudinary', '1.21.0'

gem 'meta-tags'

gem 'net-smtp'
gem 'net-pop'
gem 'net-imap'

gem 'bootsnap'

group :development do
  gem 'web-console'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'bullet'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner-mongoid', '2.0.1'
  gem 'faker'
  gem 'parallel_tests', '3.7.3'
end

group :test do
  gem 'rspec-mocks'
  gem 'webmock'
  gem 'capybara', '3.36.0'
  gem 'cuprite', '0.13'
  gem 'simplecov', '0.21.2', require: false
  gem 'simplecov-console', require: false
  gem 'simplecov-cobertura', require: false
end
