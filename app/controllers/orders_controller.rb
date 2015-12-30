class OrdersController < ApplicationController
  before_action :try_authentication

  def show
    @order = Order.find(params[:id])
    set_layout @order

    authorize @order

    if current_user && !@order.user? && current_user.persisted?
      if prev_order = @order.offering.order_for(current_user)
        @order.update! cancelled_at: Time.now
        redirect_to prev_order, alert: "The following order already exists for your account. You cannot order it again."
      else
        @order.update! user: current_user
      end
    end

    @order.create_payment unless @order.payment?

    if payable?(@order)
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
    @order = Order.new(order_create_params)
    @order.user = current_user

    authorize @order

    if @order.save
      destination = @order.questions? ? [:edit, @order] : @order

      redirect_to destination
    else
      redirect_to @order.offering, alert: @order.errors.full_messages.to_sentence
    end

    session[:order_id] = @order.id
  end

  def edit
    @order = Order.find(params[:id])
    set_layout @order

    authorize @order

    @order.questions.each do |question|
      if @order.answers.where(question_id: question.id).none?
        @order.answers.build question_id: question.id
      end
    end
  end

  def update
    @order = Order.find(params[:id])

    authorize @order

    if @order.update order_update_params
      redirect_to @order
    else
      set_layout @order

      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])

    authorize @order

    @order.update cancelled_at: Time.now
    redirect_to @order.offering
  end

  private

  def set_layout(order)
    @layout = order.offering.layout
  end

  # This overrides the Pundit default because we need access to the session
  def policy(order)
    OrderPolicy.new(current_user, order, session)
  end

  def payable?(order)
    @order.payable? && params[:cancelled].blank? && current_user.present?
  end

  def order_create_params
    params.require(:order).permit(:offering_id, purchases_attributes: :product_id)
  end

  def order_update_params
    params.require(:order).permit(answers_attributes: [:id, :question_id, :value])
  end
end
