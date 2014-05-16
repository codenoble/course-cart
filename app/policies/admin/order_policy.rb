class Admin::OrderPolicy < Admin::ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  class Scope < Admin::ApplicationPolicy::Scope
  end
end