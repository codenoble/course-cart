class OrdersController < ApplicationController
  # TODO: authorization

  def show
    @order = Order.find(params[:id])

    @order.create_payment unless @order.payment?

    store_id = Settings.touch_net.upay_store_id
    context = Settings.touch_net.context
    passed_amount_validation_key = Settings.touch_net.passed_amount_validation_key
    success_link = nil # TODO: production_url(@production, processed: @credit.transaction.uuid)
    cancel_link =  nil # TODO: production_url(@production, cancelled: @credit.transaction.uuid)
    production = Rails.env.production?

    @upay = TouchNet::UPay.new(store_id, context, passed_amount_validation_key, production)
    @upay_parameters = @upay.parameters_for(@order, success_link: success_link, cancel_link: cancel_link)
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.save
      redirect_to @order
    else
      raise 'pry'
      redirect_to :back, alert: @order.errors.full_messages
    end
  end

  private

  def order_params
    params.require(:order).permit(purchases_attributes: :product_id)
  end
end