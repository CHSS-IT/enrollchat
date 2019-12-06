class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require 'csv'

  before_action :retrieve_settings, :set_terms, :set_graduate_threshold, :set_undergraduate_threshold,:set_current_term, :set_term, :set_recent_comments

  def retrieve_settings
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

  helper_method :current_user

  private

  def ensure_admin!
    unless current_user.try(:admin?)
      redirect_to sections_path, notice: 'You do not have access to this page.'
    end
  end

  def current_user
    @current_user ||= set_current_user
    @current_user if defined?(@current_user)
  end

  def get_current_user
    if session['cas']
      User.find_by_username(session['cas']['user'].downcase.strip)
    end
  end

  def set_current_user
    if session['cas']
      user = get_current_user
      if user
        if !user.active_session
          user.update_login_stats!(request)
          user
        else
          user
        end
      end
    end
  end

  def authenticate_user!
    if session['cas'].nil?
      render status: 401, plain: "Redirecting to login..."
    elsif session['cas']
      unless User.find_by_username(session['cas']['user'].downcase.strip)
        redirect_to unregistered_path, notice: 'You are not registered to use this system.'
      end
    end
  end
end
