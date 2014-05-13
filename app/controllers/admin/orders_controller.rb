class Admin::OrdersController < Admin::ApplicationController
  respond_to :html

  def index
    @orders = Order.all
    @orders = @orders.cancelled if params[:cancelled] == 'true'
    @orders = @orders.uncancelled if params[:cancelled] == 'false'
    @orders = @orders.pending_payment if params[:status] == "pending_payment"
    @orders = @orders.paid if params[:status] == "paid"
    @orders = @orders.page(params[:page])
  end

  def show
  end
end