require 'rack-cas/session_store/rails/mongoid'
Rails.application.config.session_store :rack_cas_mongoid_store, key: '_course_cart_session'
