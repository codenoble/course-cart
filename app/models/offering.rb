class Offering
  include Mongoid::Document
  include Mongoid::Slug

  has_many :products
  has_many :orders
  field :name, type: String
  field :period, type: Range # Times
  field :layout, type: Symbol
  field :preflight_checks, type: Hash
  field :order_validators, type: Hash
  field :order_warners, type: Hash
  field :default, type: Boolean # have the default route redirect to this

  validates :name, presence: true, uniqueness: true

  slug :name, history: true

  # NOTE: be sure to store times in UTC or you'll have offset issues
  scope :open, -> do
    now = Time.now
    # TODO: test me
    scoped.
      or(period: nil).
      or(:'period.min'.lt => now, :'period.max'.gt => now).
      or(:'period.min'.lt => now, :'period.max' => nil)
  end

  def open?
    period.nil? || period == (nil..nil) || period.cover?(Time.now)
  end

  alias :to_s :name
end
