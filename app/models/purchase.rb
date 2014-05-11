class Purchase
  include Mongoid::Document

  embedded_in :order
  belongs_to :product

  validates :product, presence: true
  validate :product_available, on: :create

  delegate :offering, :slug, to: :product, allow_nil: true

  private

  def product_available
    errors.add(:product, 'has been sold out') if product.sold_out?
  end
end