class StaticPagesController < ApplicationController
  def home
    if current_user
      redirect_to sections_path
    else
      render layout: "landing"
    end
  end

  def unregistered
    render layout: "unregistered_landing"
  end
end
