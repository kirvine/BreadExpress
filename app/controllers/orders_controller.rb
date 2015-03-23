class OrdersController < ApplicationController
	before_action :set_order, only: [:show, :edit, :update, :destroy]

	def index
		# list all orders that have been paid for
		@orders = Order.chronological.paginate(page: params[:page]).per_page(10)
	end

  def show
    @order_history = @order.customer.orders.chronological.to_a
  end

	def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      @order.date = Date.today
      @order.pay
      redirect_to order_path(@order), notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to order_path(@order), notice: "#{@order.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url
  end

	private
	def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:grand_total, :customer_id, :address_id)
  end
end
