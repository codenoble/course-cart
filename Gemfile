source 'https://rubygems.org'

gem 'rails', '4.1.7.1'

gem 'biola_deploy'
gem 'biola_frontend_toolkit'
gem 'blazing'
gem 'bootstrap-sass'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'coffee-rails', '~> 4.0.0'
gem 'font-awesome-rails'
gem 'jquery-rails', '~> 3.1.3'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'mongoid', '~> 4.0'
gem 'mongoid_slug'
gem 'newrelic_rpm'
gem 'pinglish'
gem 'puma'
gem 'pundit'
gem 'rack-cas', '>= 0.9.2'
gem 'rails_config'
gem 'sass-rails', '~> 4.0.4'
gem 'slim'
gem 'therubyracer',  platforms: :ruby
gem 'turbolinks'
gem 'turnout'
gem 'uglifier', '>= 1.3.0'

group :development, :staging, :production do
  gem 'ruby-oci8', require: 'oci8'
end

group :development, :test do
  gem 'pry'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'factory_girl'
  gem 'faker'
  gem 'launchy'
  gem 'mongoid-rspec'
  gem 'rspec-rails'
end

group :staging, :production do
  gem 'rack-ssl', require: 'rack/ssl'
end

group :production do
  gem 'sentry-raven'
end
