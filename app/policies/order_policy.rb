class OrderPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def create?
    true
  end

  alias :edit? :show?
  alias :update? :show?
  alias :destroy? :show?
end
