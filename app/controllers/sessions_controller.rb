class SessionsController < ApplicationController

  before_action :find_user, only: :end_session

  def end_session
    @user.active_session = false
    @user.save!(touch: false)
    redirect_to '/logout'
  end

  private

  def find_user
    @user = User.find(@current_user.id)
  end
end