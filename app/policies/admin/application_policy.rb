class Admin::ApplicationPolicy < ::ApplicationPolicy
  ADMIN_ROLES = [:admin, :developer]

  def initialize(user, record)
    unless user.has_role?(*ADMIN_ROLES)
      raise Pundit::NotAuthorizedError, 'not an admin'
    end

    super
  end

  public

  class Scope < ::ApplicationPolicy::Scope
    def initialize(user, record)
      unless user.has_role?(*ADMIN_ROLES)
        raise Pundit::NotAuthorizedError, 'not an admin'
      end

      super
    end
  end
end
