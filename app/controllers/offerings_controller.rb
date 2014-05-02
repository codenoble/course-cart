class OfferingsController < ApplicationController
  def index
    # TODO: limit by period
    @offerings = Offering.all
  end

  def show
    @offering = Offering.find(params[:id])
    @order = Order.find_or_initialize_by(user: current_user, offering: @offering)
    @layout = @offering.layout

    if @order.persisted?
      redirect_to @order
    else
      @offering.products.each do |product|
        @order.purchases.build product: product
      end
    end
  end
end