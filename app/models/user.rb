class User
  include Mongoid::Document

  has_many :orders
  field :username, type: String
  field :id_number, type: Integer
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :photo_url, type: String
  field :entitlements, type: Array
  field :affiliations, type: Array

  alias_attribute :netid, :username

  validates :username, presence: true, uniqueness: true

  def name
    "#{self.first_name} #{self.last_name}".strip
  end
  alias :to_s :name
end