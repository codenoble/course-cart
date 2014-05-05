class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :offering
  embeds_many :purchases
  embeds_one :payment

  accepts_nested_attributes_for :purchases, reject_if: -> (hash) { hash[:product_id].blank? }

  before_validation :set_offering

  validates :user, presence: true
  validates :offering, presence: true, uniqueness: {scope: :user}
  validate :validations_from_offering
  validates :purchases, length: { minimum: 1}

  def total
    purchases.map { |p| p.product.price }.sum
  end

  def complete?
    !!payment.try(:successful?)
  end

  def to_s
    created_at.to_s
  end

  private

  def set_offering
    self.offering = purchases.first.try(:offering)
  end

  def validations_from_offering
    Array(offering.order_validators).each do |validator|
      validates_with validator.constantize
    end
  end
end