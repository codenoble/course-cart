class Collection
  include Mongoid::Document
  include Mongoid::Slug

  has_and_belongs_to_many :products
  field :name, type: String
  field :period, type: Range # Times
  field :layout, type: Symbol

  validates :name, presence: true, uniqueness: true

  slug :name

  alias :to_s :name
end