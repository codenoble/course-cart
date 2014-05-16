class OrderPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def create?
    true
  end

  alias :destroy? :show?
end