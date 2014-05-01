class CollectionsController < ApplicationController
  def index
    # TODO: limit by period
    @collections = Collection.all
  end

  def show
    @collection = Collection.find(params[:id])
    @order = Order.new
    @collection.products.each do |product|
      @order.purchases.build product: product
    end

    # TODO: render with layout
  end
end