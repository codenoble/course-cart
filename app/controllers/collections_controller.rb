class CollectionsController < ApplicationController
  def index
    @collections = Collection.all
  end

  def show
    @collection = Collection.find(params[:id])
    @order = Order.new
    @collection.products.each do |product|
      @order.purchases.build product: product
    end
  end
end