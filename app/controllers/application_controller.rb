class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require 'csv'

  before_action :set_terms, :set_term, :get_recent_comments

  def set_terms
    @terms = Section.select(:term).distinct(:term).order(term: :desc)
  end

  def set_term
    logger.debug('Set Term!')
    # Only allow six digit terms
    unless /\Ad{6}/.match(params[:term])
      logger.debug("Improper term.")
      params[:term] == nil
    end
    if params[:term].present?
      logger.debug("Term param present.")
      @term = params[:term]
    elsif cookies[:term].present?
      logger.debug("Term cookie present.")
      @term = cookies[:term]
    else
      logger.debug("Setting to maximum term.")
      @term = Section.maximum(:term)
    end
    cookies[:term] = @term unless cookies[:term] == @term
  end

  def get_recent_comments
    @recent_comments = Comment.recent
  end

end
