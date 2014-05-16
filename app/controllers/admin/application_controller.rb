class Admin::ApplicationController < ::ApplicationController
  include AdminPolicies

  layout 'admin/application'
end