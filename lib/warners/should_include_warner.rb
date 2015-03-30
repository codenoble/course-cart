class ShouldIncludeWarner < Warners::Base
  # Example: Order#order_warners = {'ShouldIncludewarner' => {if_ordering_more_than: 1, product_names: ['BBST 110']}}
  def warnings
    if ordering_enough? && doesnt_include_products?
      options[:message] || "It is recommended that orders #{options[:if_ordering_more_than] ? "of more than #{options[:if_ordering_more_than]} products" : ''} include #{product_names.to_sentence}"
    end
  end

  private

  def product_names
    Array(options[:product_names])
  end

  def ordering_enough?
    order.purchases.length > (options[:if_ordering_more_than].to_i)
  end

  def doesnt_include_products?
    !product_names.all? do |matcher|
      order.purchases.any? { |p| p.product.to_s.downcase.include?(matcher.to_s.downcase) }
    end
  end
end
