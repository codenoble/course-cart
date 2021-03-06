class Purchase
  include Mongoid::Document

  embedded_in :order
  belongs_to :product

  validates :product, presence: true

  delegate :offering, :slug, to: :product, allow_nil: true
end
