class Answer
  include Mongoid::Document

  embedded_in :order
  field :question_id, type: String
  field :value

  delegate :offering, to: :order
  delegate :name, to: :question
  delegate :type, to: :question
  delegate :options, to: :question
  delegate :required?, to: :question, allow_nil: true

  validates :question_id, presence: true
  validate do
    errors.add(:question_id, 'is invalid') unless question.present?

    if required? && (value.blank? || (type == :check_box) && value == 'No')
      errors.add :value, 'is required'
    end
  end

  def question
    @question ||= offering.questions.where(_id: question_id).first
  end
end
