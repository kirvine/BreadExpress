class ItemsController < ApplicationController
  # before_action :check_login
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    if logged_in? && !current_user.role?(:customer)
      @bread = Item.for_category("bread").paginate(:page => params[:page]).per_page(10)
      @muffins = Item.for_category("muffins").paginate(:page => params[:page]).per_page(10)
      @pastries = Item.for_category("pastries").paginate(:page => params[:page]).per_page(10)
    else
      @bread = Item.active.for_category("bread").paginate(:page => params[:page]).per_page(10)
      @muffins = Item.active.for_category("muffins").paginate(:page => params[:page]).per_page(10)
      @pastries = Item.active.for_category("pastries").paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @related_items = Item.for_category("#{@item.category}")
  end

  def new
    @item = Item.new
    item_price = @item.item_prices.build
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    @item.item_prices.each do |item_price|
      item_price.item = @item
    end
    
    if @item.save
      redirect_to itemes_path, notice: "The item was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to itemes_path, notice: "The item was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "The item was removed from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active, item_prices_attributes: [:id, :price, :start_date, :_destroy])
  end

end