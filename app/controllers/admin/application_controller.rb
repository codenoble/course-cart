class Admin::ApplicationController < ::ApplicationController
  include AdminPolicies

  layout 'admin/application'
  before_action :authenticate!
end
