class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :try_cas_gateway_login, :check_authentication_param
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden_page

  layout -> { (@layout || :application).to_s }

  helper_method :current_user
  def current_user
    authentication.user
  end

  protected

  def try_cas_gateway_login
    unless current_user.present? || session[:gateway_login_attempted] || Rails.env.test?
      cas_server = RackCAS::Server.new(Settings.cas.url)

      session[:gateway_login_attempted] = true
      redirect_to cas_server.login_url(request.url, gateway: true).to_s
    end
  end

  def check_authentication_param
    if params[:login] == 'true' && current_user.nil?
      render_error_page 401
      false
    end
  end

  def authenticate!
    authentication.perform or render_error_page(401)
  end

  def try_authentication
    authenticate! if current_user
  end

  def authentication
    @authentication ||= CasAuthentication.new(session)
  end

  def render_forbidden_page
    render_error_page 403
  end

  def render_error_page(status)
    render file: "#{Rails.root}/public/#{status}", formats: [:html], status: status, layout: false
  end
end
