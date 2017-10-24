class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require 'csv'

  before_action :set_terms

  def set_terms
    @terms = Section.select(:term).distinct(:term).order(term: :desc)
  end

end
