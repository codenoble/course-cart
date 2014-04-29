class Product
  include Mongoid::Document

  embedded_in :category
  field :name, type: String
  field :price, type: BigDecimal
  mount_uploader :photo, PhotoUploader

  alias :to_s :name
end