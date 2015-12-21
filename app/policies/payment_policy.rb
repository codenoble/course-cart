class PaymentPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(posting_key, record)
    raise Pundit::NotAuthorizedError, 'no posting key' unless posting_key

    @user = posting_key
    @record = record
  end

  def update?
    posting_key == record.order.offering.posting_key
  end

  private

  alias :posting_key :user
end
