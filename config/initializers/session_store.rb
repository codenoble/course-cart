# require 'rack-cas/session_store/rails/mongoid'
# Rails.application.config.session_store :rack_cas_mongoid_store

Rails.application.config.session_store :cookie_store, key: '_course-cart_session'
