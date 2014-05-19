class Admin::OrdersController < Admin::ApplicationController
  respond_to :html

  def index
    @orders = admin_policy_scope(Order)
    @orders = @orders.where(offering_id: params[:offering]) if params[:offering]
    @orders = @orders.cancelled if params[:status] == 'cancelled'
    @orders = @orders.pending_payment if params[:status] == "pending_payment"
    @orders = @orders.paid if params[:status] == "paid"
    @orders = @orders.page(params[:page])
  end

  def show
    @order = Order.find(params[:id])

    admin_authorize @order
  end
end