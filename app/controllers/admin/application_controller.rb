class Admin::ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'admin/application'
  helper_method :current_user

  before_action :authenticate!

  before_filter :set_current_user

  protected

  def current_user
    authentication.user
  end

  def set_current_user
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