class Admin::OrdersController < Admin::ApplicationController
  respond_to :html
  require 'csv'

  def index
    @orders = admin_policy_scope(Order)
    @orders = @orders.where(offering_id: params[:offering]) if params[:offering]
    @orders = @orders.cancelled if params[:status] == 'cancelled'
    @orders = @orders.pending_payment if params[:status] == "pending_payment"
    @orders = @orders.paid if params[:status] == "paid"
    # This keeps the pagination out of the csv file.
    @csv_orders = @orders
    @orders = @orders.page(params[:page])

    respond_to do |format|
      format.html
      format.csv { send_data csv(@csv_orders) }
    end
  end

  def show
    @order = Order.find(params[:id])

    admin_authorize @order
  end

  private
  def csv(orders)
    CSV.generate do |csv|
      column_names = [:name, :id, :email, :courses, :last_change, :status, :offering, :answers]
      csv << column_names
      orders.each do |o|
        csv << o.to_csv.values_at(*column_names)
      end
    end
  end
end
