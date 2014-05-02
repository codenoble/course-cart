class Product
  include Mongoid::Document

  belongs_to :offering
  field :name, type: String
  field :price, type: BigDecimal
  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true

  alias :to_s :name
end