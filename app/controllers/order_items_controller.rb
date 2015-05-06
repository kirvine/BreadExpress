class OrderItemsController < ApplicationController
	before_action :check_login
  before_action :set_order_item, only: [:edit, :update]
  authorize_resource

  def edit
  	unless params[:status].nil?
      if params[:status].match(/shipped/) # == 'deactivate_prj' || params[:status] == 'deactivate_asgn'
        @order_item.update_attribute(:shipped_on, Date.today)
        flash[:notice] = "The order item has been shipped on #{@order_item.shipped_on}"
      elsif params[:status].match(/activate/) # == 'activate_prj' || params[:status] == 'activate_asgn'
        @order_item.update_attribute(:active, true)
        flash[:notice] = "#{@order_item.user.proper_name} was made active."
      end
      redirect_to project_path(@order_item.project) if params[:status].match(/_prj/)
      redirect_to shipping_list_path if params[:status].match(/_asgn/)
    end
  end


  private
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:order_id, :item_id, :quantity, :shipped_on)  
  end

end