class Collection
  include Mongoid::Document

  has_and_belongs_to_many :products
  field :name, type: String
  field :period, type: Range # Times
  field :layout, type: Symbol

  validates :name, presence: true, uniqueness: true

  alias :to_s :name
end