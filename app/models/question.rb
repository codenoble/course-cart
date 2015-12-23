class Question
  include Mongoid::Document

  TYPES = {
    'Short Text' => :text_field,
    'Long Text' => :text_area,
    'Checkbox' => :check_box,
    'Drop down' => :select
  }

  embedded_in :offering

  field :name, type: String
  field :type, type: Symbol
  field :options, type: Array
  field :required, type: Boolean

  validates :name, :type, presence: true
  validates :type, inclusion: {in: TYPES.values}
  validates :options, presence: {if: -> (q) { q.type == :select }}
  validates :options, absence: {if: -> (q) { q.type != :select }}

  def slug
    name.parameterize('_')
  end
end
