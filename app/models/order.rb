class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :offering
  embeds_many :purchases
  embeds_one :payment
  field :cancelled_at, type: Time

  accepts_nested_attributes_for :purchases, reject_if: -> (hash) { hash[:product_id].blank? }

  before_validation :set_offering

  validates :user, presence: true
  validates :offering, presence: true, uniqueness: {scope: :user, conditions: -> { where(cancelled_at: nil) }}
  validates :purchases, length: { minimum: 1, message: 'is empty. Please select at least one product.'}
  validates :cancelled_at, absence: {:if => -> order { order.complete? }}
  validate :offering_open, on: :create
  validate :products_available, on: :create
  validate :preflight_checks, on: :preflight
  validate :validations_from_offering, on: [:create, :update]

  scope :cancelled, -> { where(:cancelled_at.ne => nil) }
  scope :uncancelled, -> { where(cancelled_at: nil) }

  scope :paid, -> { where('payment.status' => :success ) }
  scope :pending_payment, -> { uncancelled.where('payment.gateway_transaction_id' => nil) }

  def preflight_passed?
    valid? :preflight
  end

  def warnings
    Hash(offering.order_warners).map { |warner, options|
      warner.constantize.new(self, options).warnings
    }.compact
  end

  def status
    if complete?
      'Paid'
    elsif cancelled?
      'Cancelled'
    elsif pending_payment?
      'Pending Payment'
    end
  end

  def status_class
    if complete?
      :success
    elsif cancelled?
      :warning
    elsif pending_payment?
      :info
    end
  end

  def open?
    !complete? && !cancelled?
  end

  alias :cancelled? :cancelled_at?

  def complete?
    !!payment.try(:successful?)
  end

  def pending_payment?
    !!payment.try(:pending?)
  end

  def total
    purchases.map { |p| p.product.price }.sum
  end

  def to_s
    created_at.to_s
  end

  def to_csv
    {
      name: user.name,
      id: user.id_number,
      email: user.email,
      courses: purchases.map{|p| p.product.name},
      last_change: updated_at,
      status: status,
      offering: offering.name
    }
  end

  private

  def set_offering
    self.offering = purchases.first.try(:offering) || self.offering
  end

  def offering_open
    errors.add(:offering, 'is not open') unless offering.open?
  end

  def preflight_checks
    validate_from_hash offering.preflight_checks
  end

  def validations_from_offering
    validate_from_hash offering.order_validators
  end

  private

  def validate_from_hash(validators_hash)
    validators_hash = Hash(validators_hash)

    validators_hash.each do |validator, options|
      options = Hash(options).with_indifferent_access

      validates_with validator.constantize, options
    end
  end

  def products_available
    purchases.map(&:product).each do |product|
      errors.add(:base, "#{product} has been sold out") if product.sold_out?
    end
  end
end
