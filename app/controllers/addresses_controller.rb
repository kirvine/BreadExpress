class AddressesController < ApplicationController
	before_action :set_address, only: [:show, :edit, :update, :destroy]

	def index
		@active_addresses = Address.active.by_customer.paginate(page: params[:page]).per_page(10)
    @inactive_addresses = Address.inactive.by_customer.paginate(page: params[:page]).per_page(10)
  end

  def show
  end

	def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      redirect_to address_path(@address), notice: "A new address was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @address.update(address_params)
      redirect_to address_path(@address), notice: "An address was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_url, notice: "Address was successfully removed from the system."
  end

	private
	def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:customer_id, :is_billing, :recipient, :street_1, :street_2, :city, :state, :zip, :active)
  end
end
