ENV["RAILS_ENV"] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

FactoryGirl.find_definitions
Mongoid.load!('spec/config/mongoid.yml')
Capybara.asset_host = Settings.dev_url

Dir[Rails.root.join('spec/support/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Mongoid::Matchers, type: :model

  config.infer_spec_type_from_file_location!

  # Clean/Reset Mongoid DB prior to running each test.
  config.before(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
