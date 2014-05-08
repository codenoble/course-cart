require 'oci8'

class SmartStartEligibilityValidator < ActiveModel::Validator
  def validate(record)
    id_number = record.user.id_number.to_s.rjust(8, '0')
    conn = OCI8.new(Settings.banner.connection_string)
    # TODO: check term
    cursor = conn.exec('SELECT id FROM bsv_smartstart WHERE id = :1', id_number)
    row = cursor.fetch

    unless row.try(:first) == id_number
      record.errors[:base] << 'You are not eligible for Smart Start classes'
    end

    cursor.close
    conn.logoff
  end
end