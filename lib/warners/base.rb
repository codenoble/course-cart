class Warners::Base
  attr_reader :order
  attr_reader :options

  def initialize(order, options)
    @order = order
    @options = options
  end

  def warnings
    raise NotImplementedError, 'Subclasses must override this method'
  end

  def any?
    Array(warnings).any?
  end
end
