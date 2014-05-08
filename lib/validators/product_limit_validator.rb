require 'oci8'

class ProductLimitValidator < ActiveModel::Validator
  include ActionView::Helpers::TextHelper

  def validate(record, options = {})
    limit = options[:limit] || 1

    if record.purchases.length > limit
      record.errors[:base] << "Only #{pluralize(limit, 'product')} can be orderd"
    end
  end
end