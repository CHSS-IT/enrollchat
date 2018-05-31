class StaticPagesController < ApplicationController
  def home
    render layout: "landing"
  end
end
