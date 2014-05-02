class OrdersController < ApplicationController
  # TODO: authorization

  def show
    @order = Order.find(params[:id])

    @order.create_payment unless @order.payment?

    unless @order.complete?
      store_id = Settings.touch_net.upay_store_id
      context = Settings.touch_net.context
      passed_amount_validation_key = Settings.touch_net.passed_amount_validation_key
      success_link = order_url(@order)
      cancel_link =  nil # TODO
      production = Settings.touch_net.production || Rails.env.production?

      @upay = TouchNet::UPay.new(store_id, context, passed_amount_validation_key, production)
      @upay_parameters = @upay.parameters_for(@order, success_link: success_link, cancel_link: cancel_link)
    end
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.save
      redirect_to @order
    else
      redirect_to :back, alert: @order.errors.full_messages
    end
  end

  private

  def order_params
    params.require(:order).permit(purchases_attributes: :product_id)
  end
end