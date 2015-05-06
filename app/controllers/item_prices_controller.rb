class ItemPricesController < ApplicationController
	before_action :check_login
  before_action :set_item_prices, only: [:new]
  authorize_resource

  def new
  end

  def create
    @item_price = ItemPrice.new(item_prices_params)
    
    if @item_price.save
      redirect_to item_path(@item_price.item), notice: "A new price was added."
    else
      render action: 'new'
    end
  end

private
  def set_item_price
    @item_price = ItemPrice.find(params[:id])
  end

  def item_price_params
    params[:item_price][:start_date] = Date.today
    params[:item_price][:end_date] = nil
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end
end