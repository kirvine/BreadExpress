class SessionsController < ApplicationController

  include BreadExpressHelpers::Cart

  def new
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      create_cart
      if current_user.role?(:admin)
        redirect_to dashboard_path, notice: "Logged in!"
      elsif current_user.role?(:customer)
        redirect_to customer_path(current_user.customer), notice: "Logged in!"
      elsif current_user.role?(:baker)
        redirect_to baking_list_path, notice: "Logged in!"
      else
        redirect_to shipping_list_path, notice: "Logged in!"
      end
    else
      flash.now.alert = "Username or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart
    redirect_to root_url, notice: "Logged out!"
  end
end