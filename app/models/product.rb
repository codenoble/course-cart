class Product
  include Mongoid::Document
  include Mongoid::Slug

  belongs_to :offering
  field :name, type: String
  field :price, type: BigDecimal
  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true

  slug :name

  alias :to_s :name
end