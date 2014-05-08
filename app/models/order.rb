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
  validates :purchases, length: { minimum: 1}
  validate :offering_open, on: :create
  validate :preflight_checks, on: :preflight
  validate :validations_from_offering, on: [:create, :update]

  def preflight_passed?
    valid? :preflight
  end

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

  def offering_open
    errors.add(:offering, 'is not open') unless offering.open?
  end

  def preflight_checks
    Array(offering.preflight_checks).each do |validator|
      validates_with validator.constantize
    end
  end

  def validations_from_offering
    Array(offering.order_validators).each do |validator|
      validates_with validator.constantize
    end
  end
end