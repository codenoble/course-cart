class YesManValidator < ActiveModel::Validator
  include ActionView::Helpers::TextHelper

  def validate(record, options = {})
      # never raises a validation error
  end
end