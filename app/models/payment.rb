class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :order
  field :uuid, type: String
  field :gateway_transaction_id, type: String
  field :status, type: Symbol
  field :tracking_id, type: Integer
  field :amount, type: BigDecimal
  field :succeeded_at, type: DateTime
  field :details, type: Hash

  validates :uuid, presence: true

  before_validation :generate_uuid

  # These attributes map to TouchNet uPay parameters
  alias_attribute :ext_trans_id, :uuid
  alias_attribute :tpg_trans_id, :gateway_transaction_id
  alias_attribute :pmt_status, :status
  alias_attribute :sys_tracking_id, :tracking_id
  alias_attribute :pmt_amt, :amount

  def pending?
    gateway_transaction_id.nil?
  end

  def successful?
    status == :success
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end