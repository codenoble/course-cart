class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate!

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
