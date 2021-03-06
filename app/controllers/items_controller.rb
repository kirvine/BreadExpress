class ItemsController < ApplicationController
  include BreadExpressHelpers::Cart

  # before_action :check_login
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def add_item
    add_item_to_cart(params[:id])
    @item = Item.find(params[:id])
    redirect_to item_path(@item), notice: "1 order of #{@item.name} was added to your cart"
  end

  def remove_item
    remove_item_from_cart(params[:id])
    redirect_to cart_path, notice: "The item was removed from your cart"
  end

  def index
    if logged_in? && current_user.role?(:admin)
      @active_items = Item.active.all
      @inactive_items = Item.inactive.all
      @bread = Item.for_category("bread").alphabetical.paginate(:page => params[:page]).per_page(10)
      @muffins = Item.for_category("muffins").alphabetical.paginate(:page => params[:page]).per_page(10)
      @pastries = Item.for_category("pastries").alphabetical.paginate(:page => params[:page]).per_page(10)
    else
      @bread = Item.active.for_category("bread").alphabetical.paginate(:page => params[:page]).per_page(10)
      @muffins = Item.active.for_category("muffins").alphabetical.paginate(:page => params[:page]).per_page(10)
      @pastries = Item.active.for_category("pastries").alphabetical.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @related_items = Item.active.similar_items(@item.category, @item.id)
    @item_price = ItemPrice.new
  end

  def new
    @item = Item.new
    @item.item_prices.build
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    @item.item_prices.each do |item_price|
      item_price.item = @item
      item_price.start_date = Date.today
      item_price.end_date = nil
    end
    
    if @item.save
      redirect_to item_path(@item), notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to items_path, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "#{@item.name} was removed from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    # reset_date_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active, item_prices_attributes: [:id, :price, :start_date, :end_date])
  end

  def reset_date_params
    params[:item][:item_prices_attributes][:start_date] = Date.today
    params[:item][:item_prices_attributes][:end_date] = nil
  end
end