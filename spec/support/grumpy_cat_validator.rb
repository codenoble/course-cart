class GrumpyCatValidator < ActiveModel::Validator
  include ActionView::Helpers::TextHelper

  def validate(record, options = {})
      record.errors[:base] << "NO!"
  end
end