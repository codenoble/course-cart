class Product
  include Mongoid::Document

  field :name, type: String
  field :price, type: BigDecimal
  mount_uploader :photo, PhotoUploader

  alias :to_s :name
end