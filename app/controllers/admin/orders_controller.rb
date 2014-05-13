class Admin::OrdersController < Admin::ApplicationController
  respond_to :html

  def index
    @orders = Order.all.page(params[:page])
  end

  def show
  end
end