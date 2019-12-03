class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :checked_activities, :archive]
  before_action :ensure_admin!, except: [:edit, :update, :checked_activities]
  before_action :editable?, only: [:edit, :update]
  #before_action :authenticate_user!

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

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        if current_user.try(:admin?)
          format.html { redirect_to users_url, notice: 'User was succesfully updated' }
        else
          format.html { redirect_to sections_url, notice: 'Preferences updated' }
        end
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

  def archive
    @user.update(email_preference: 'No Emails', no_weekly_report: true, status: 'archived', admin: false, departments: [])
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User has been archived" }
    end
  end

  private

  def editable?
    unless current_user == @user || current_user.try(:admin?)
      redirect_to sections_path, notice: 'You do not have access to this page'
      return false
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    allowed_params = [:first_name, :last_name, :email, :username, :email_preference, :no_weekly_report, { departments: [] }]
    allowed_params += [:admin, :status] if current_user.is_admin?
    params.require(:user).permit(allowed_params)
  end
end
