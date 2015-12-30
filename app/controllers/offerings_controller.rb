class OfferingsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def show
    @offering = if params[:id]
      Offering.find(params[:id])
    else
      Offering.where(default: true).open.first
    end

    render_error_page(404) and return if @offering.nil?

    @layout = @offering.layout

    @order = if current_user.present?
      Order.find_or_initialize_by(user: current_user, offering: @offering, cancelled_at: nil)
    else
      Order.new(offering: @offering, cancelled_at: nil)
    end

    if @order.persisted?
      redirect_to @order
    else
      @offering.products.each do |product|
        @order.purchases.build product: product
      end
    end
  end
end
