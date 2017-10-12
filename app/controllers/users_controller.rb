class UsersController < ApplicationController
  before_action :ensure_admin!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'User was succesfully created' }
      else
        format.html { redirect_to new_user_url, notice: 'Error: Could not create user' }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'User was succesfully updated' }
      else
        format.html { redirect_to edit_user_url(@user), notice: 'Error: Could not update user' }
      end
    end
  end

  private

  def ensure_admin!
    unless current_user.admin?
      redirect_to root_path, notice: 'You do not have access to this page'
      return false
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :username, :admin)
  end

end
