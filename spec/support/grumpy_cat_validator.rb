class GrumpyCatValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << 'NO!'
  end
end