source 'https://rubygems.org'

gem 'rails', '4.1.5'

gem 'biola_deploy'
gem 'blazing'
gem 'bootstrap-sass'
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'coffee-rails', '~> 4.0.0'
gem 'exception_notification'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'mongoid', '~> 4.0'
gem 'mongoid_slug'
gem 'newrelic_rpm'
gem 'pinglish'
gem 'pundit'
gem 'rack-cas', '>= 0.9.2'
gem 'rails_config'
gem 'sass-rails', '~> 4.0.3'
gem 'slim'
gem 'therubyracer',  platforms: :ruby
gem 'turbolinks'
gem 'turnout'
gem 'uglifier', '>= 1.3.0'

group :development, :staging, :production do
  gem 'ruby-oci8', require: 'oci8'
end

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'spring'
end

group :test do
  gem 'factory_girl'
  gem 'faker'
end

group :staging, :production do
  gem 'rack-ssl', require: 'rack/ssl'
end
