class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :purchases

  validates :user, presence: true

  def to_s
    created_at.to_s
  end
end