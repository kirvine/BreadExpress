class CustomersController < ApplicationController
	before_action :set_customer, only: [:show, :edit, :update, :destroy]

	def index
		# find all customers in alphabetical order
		@customers = Customer.active.alphabetical.paginate(page: params[:page]).per_page(10)
	end

  def show
    @order_history = @customer.orders.paid.to_a
  end

	def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to customer_path(@customer), notice: "#{@customer.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "#{@customer.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_url, notice: "#{@customer.name} was successfully removed from the system."
  end

	private
	def set_cusomer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name)
  end
end
