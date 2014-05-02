class Offering
  include Mongoid::Document
  include Mongoid::Slug

  has_many :products
  has_many :orders
  field :name, type: String
  field :period, type: Range # Times
  field :layout, type: Symbol

  validates :name, presence: true, uniqueness: true

  slug :name

  alias :to_s :name
end