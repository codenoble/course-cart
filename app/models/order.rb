class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :purchases
  embeds_one :payment

  accepts_nested_attributes_for :purchases, reject_if: -> (hash) { hash[:product_id].blank? }

  validates :user, presence: true
  # TODO: validate at least one purchase
  # TODO: validate rules

  def total
    purchases.map { |p| p.product.price }.sum
  end

  def complete?
    !!payment.try(:successful?)
  end

  def to_s
    created_at.to_s
  end
end