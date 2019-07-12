class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require 'csv'

  before_action :get_settings, :set_terms, :set_graduate_threshold, :set_undergraduate_threshold,:set_current_term, :set_term, :set_recent_comments

  def get_settings
    @settings = Setting.first_or_create!(singleton_guard: 0)
  end

  def set_terms
    @terms = Section.select(:term).distinct(:term).order(term: :desc)
  end

  def set_graduate_threshold
    Section.graduate_enrollment_threshold = @settings.graduate_enrollment_threshold
  end

  def set_undergraduate_threshold
    Section.undergraduate_enrollment_threshold = @settings.undergraduate_enrollment_threshold
  end

  def set_current_term
    @current_term = @settings.current_term
  end

  def set_term
    # Only allow six digit terms
    unless /\Ad{6}/.match(params[:term])
      params[:term] == nil
    end
    if params[:term].present?
      @term = params[:term]
    elsif cookies[:term].present?
      @term = cookies[:term]
    elsif @current_term
      @term = @current_term
    else
      @term = Section.maximum(:term)
    end
    cookies[:term] = @term unless cookies[:term] == @term
  end

  def set_recent_comments
    unless current_user.nil?
      if current_user.departments.present? && !current_user.is_admin?
        @recent_comments = Comment.recent_unread_by_interest(current_user).limit(25)
        @recent_comments = Comment.recent_by_interest(current_user).limit(5) if @recent_comments.blank?
      else
        @recent_comments = Comment.recent_unread(current_user).limit(25)
        @recent_comments = Comment.recent if @recent_comments.blank?
      end
    end
  end

  def set_recent_unread_comments
    @recent_unread_comments = Comment.recent_unread(current_user)
  end

  private

  def ensure_admin!
    unless current_user.try(:admin?)
      redirect_to sections_path, notice: 'You do not have access to this page'
      return false
    end
  end
end
