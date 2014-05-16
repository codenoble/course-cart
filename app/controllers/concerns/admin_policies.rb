module AdminPolicies
  extend ActiveSupport::Concern

  included do
    helper_method :admin_authorize
    helper_method :admin_policy_scope
  end

  # These are workarounds for the lack of support for namespacing in pundit
  # https://github.com/elabs/pundit/issues/12

  def admin_authorize(record, query=nil)
    klass = "Admin::#{record.model_name}Policy".constantize
    policy = klass.new(current_user, record)
    query ||= "#{params[:action]}?"

    @_policy_authorized = true

    unless policy.public_send(query)
      error = Pundit::NotAuthorizedError.new("not allowed to #{query} this #{record}")
      error.query, error.record, error.policy = query, record, policy

      raise error
    end

    true
  end

  def admin_policy_scope(scope)
    klass = "Admin::#{scope.model_name}Policy::Scope".constantize
    policy = klass.new(current_user, scope)

    @_policy_scoped = true

    policy.resolve
  end
end