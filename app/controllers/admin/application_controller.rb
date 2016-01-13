class Admin::ApplicationController < ::ApplicationController
  include AdminPolicies

  layout 'admin/application'
  skip_before_action :try_cas_gateway_login
  before_action :authenticate!
end
