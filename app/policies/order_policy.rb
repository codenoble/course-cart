class OrderPolicy < ApplicationPolicy
  attr_reader :session

  def initialize(user, record, session)
    @user = user
    @record = record
    @session = session
  end

  def show?
      record.user == user || session[:order_id] == record.id
  end

  def create?
    true
  end

  alias :edit? :show?
  alias :update? :show?
  alias :destroy? :show?
end
