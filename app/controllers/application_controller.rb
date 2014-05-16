class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  layout -> { (@layout || :application).to_s }

  helper_method :current_user
  def current_user
    authentication.user
  end

  protected

  def authenticate!
    authentication.perform or render_error_page(401)
  end

  def authentication
    @authentication ||= CasAuthentication.new(session)
  end

  def render_error_page(status)
    render file: "#{Rails.root}/public/#{status}", formats: [:html], status: status, layout: false
  end
end
