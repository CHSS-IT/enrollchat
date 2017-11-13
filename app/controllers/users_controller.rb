class UsersController < ApplicationController
  before_action :ensure_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :checked_activities]
  before_action :authenticate_user!

  def index
    @users = User.all.order(last_name: :asc)
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
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'User was succesfully updated' }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def checked_activities
    @user.checked_activities!
    head :ok, content_type: "text/html"
  end

  private

  def ensure_admin!
    unless current_user.try(:admin?)
      redirect_to sections_path, notice: 'You do not have access to this page'
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
