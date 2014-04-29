class Category
  include Mongoid::Document

  embeds_many :products
  field :name, type: String
  field :period, type: Range # Times
  field :layout, type: Symbol

  alias :to_s :name
end