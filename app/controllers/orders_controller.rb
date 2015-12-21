class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @layout = @order.offering.layout

    authorize @order

    @order.create_payment unless @order.payment?

    unless @order.complete?
      store_id = @order.offering.upay_store_id
      context = @order.offering.context
      passed_amount_validation_key = @order.offering.passed_amount_validation_key
      success_link = order_url(@order)
      cancel_link =  order_url(@order, cancelled: true)
      production = Settings.touch_net.production
      production = Rails.env.production? if production.nil?

      @upay = TouchNet::UPay.new(store_id, context, passed_amount_validation_key, production)
      @upay_parameters = @upay.parameters_for(@order, success_link: success_link, cancel_link: cancel_link)
    end
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    authorize @order

    if @order.save
      redirect_to @order
    else
      redirect_to @order.offering, alert: @order.errors.full_messages.to_sentence
    end
  end

  def destroy
    @order = Order.find(params[:id])

    authorize @order

    @order.update cancelled_at: Time.now
    redirect_to @order.offering
  end

  private

  def order_params
    params.require(:order).permit(:offering_id, purchases_attributes: :product_id)
  end
end
