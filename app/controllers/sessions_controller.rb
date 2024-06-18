class SessionsController < ApplicationController
  before_action :find_user, only: :end_session

  def end_session
    if @user
      @user.active_session = false
      @user.save!(touch: false)
    end
    redirect_to '/logout'
  end

  def destroy
    redirect_to root_path, notice: t(".success")
  end

  private

  def find_user
    @user = User.find(@current_user.id) if @current_user
  end
end
