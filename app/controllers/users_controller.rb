class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @active_users = User.active.by_role.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_users = User.inactive.by_role.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def dashboard
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      flash[:error] = "This user could not be created."
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      if current_user.role?(:admin)
        flash[:notice] = "#{@user.username} is updated."
        redirect_to @user
      elsif ( current_user.role?(:baker) | current_user.role?(:shipper) )
        flash[:notice] = "Your password was reset."
        redirect_to @user
      else
        flash[:notice] = "Your password was reset."
        redirect_to customer_path(current_user.customer)
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "Successfully removed #{@user.username} from Bread Express."
    redirect_to users_url
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :active)
  end
end
