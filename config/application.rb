require File.expand_path('../boot', __FILE__)

require 'active_model/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module CourseCart
  class Application < Rails::Application
    config.time_zone = 'Pacific Time (US & Canada)'

    config.autoload_paths += %W(#{config.root}/lib #{config.root}/lib/validators)
    config.i18n.default_locale = :en
    config.assets.precompile += %w( biola/header.css biola/header.js )
  end
end
