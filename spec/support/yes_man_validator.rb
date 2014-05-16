class YesManValidator < ActiveModel::Validator
  def validate(record)
      # never raises a validation error
  end
end