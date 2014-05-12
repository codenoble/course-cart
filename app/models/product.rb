class Product
  include Mongoid::Document
  include Mongoid::Slug

  belongs_to :offering
  field :name, type: String
  field :description, type: String
  field :price, type: BigDecimal
  field :available, type: Integer
  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true

  slug :name

  def orders
    Order.where(:'purchases.product_id' => id)
  end

  def sold_out?
    return false if available.nil?
    orders.count >= available
  end

  alias :to_s :name
end