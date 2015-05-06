class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Baking
  include BreadExpressHelpers::Shipping

  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(10)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def cart
    @items_in_cart = get_list_of_items_in_cart
    @shipping_cost = calculate_cart_shipping
    @total_cost = calculate_cart_items_cost
    @grand_total = calculate_cart_shipping + calculate_cart_items_cost
  end

  def empty_cart
    clear_cart
    redirect_to cart_path, notice: "Your cart has been emptied"
  end

  def checkout
    @items_in_cart = get_list_of_items_in_cart
    @order = Order.new
    @shipping_cost = calculate_cart_shipping
    @total_cost = calculate_cart_items_cost
    @grand_total = calculate_cart_shipping + calculate_cart_items_cost
  end

  def baking_list
    @bread = create_baking_list_for("bread")
    @muffins = create_baking_list_for("muffins")
    @pastries = create_baking_list_for("pastries")
    @qty_bread = @bread.size
    @qty_muffins = @muffins.size
    @qty_pastries = @pastries.size
    @qty_total = @qty_bread + @qty_muffins + @qty_pastries
  end

  def shipping_list
    @orders_to_ship = Order.not_shipped.order('date ASC').paginate(:page => params[:page]).per_page(10)
    @qty_orders = @orders_to_ship.size
  end

  def new
  end

  def create
    @order = Order.new(order_params)
    @order.grand_total = calculate_cart_items_cost + calculate_cart_shipping
    if @order.save
      @order.pay
      @order.save
      save_each_item_in_cart(@order)
      clear_cart
      redirect_to @order, notice: "Thank you for ordering from Bread Express!"
    else
      render action: 'new'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params[:order][:customer_id] = current_user.customer.id
    params[:order][:date] = Date.today
    params[:order][:expiration_month] = params[:order][:expiration_month].to_i
    params[:order][:expiration_year] = params[:order][:expiration_year].to_i
    params.require(:order).permit(:address_id, :customer_id, :date, :credit_card_number, :expiration_year, :expiration_month)
  end

end