class SectionsController < ApplicationController
  before_action :ensure_admin!, only: [:import, :delete_term, :toggle_resolved_section]
  before_action :authenticate_user!
  before_action :filter, only: :index

  # GET /sections
  # GET /sections.json

  def index
    @updated_at = Section.maximum(:updated_at)
  end

  def show
    @sections = Section.find(params[:id])
    @section = @sections # Hacky to reuse section partial
    @comments = @section.comments
  end

  def toggle_resolved_section
    @section = Section.find(params[:id])
    @section.toggle!(:resolved_section)
    ActionCable.server.broadcast "room_channel",
                                 section_id: @section.id,
                                 checkmark: @section.resolved_section
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = "Upload attempted but no file was attached!"
    else
      ActionCable.server.broadcast 'room_channel',
                                   message:  "Registration data import in process.",
                                   user: "System"

      feed = params[:file]

      uploader = FeedUploader.new
      uploader.store!(feed)
      puts "NEW URL:"
      puts uploader.url

      ImportWorker.perform_async(uploader.url.to_s)

    end
  end

  def delete_term
    @sections = Section.in_term(params[:term]).update_all(delete_at: DateTime.now().next_month)
    redirect_to sections_path, notice: "All sections and comments from term #{params[:term]} are marked for deletion."
  end

  private

  def filter
    @sections = Section.includes(:comments).in_term(@term).by_department.by_section_and_number
    unless params[:section].blank?
      logger.debug('FILTERING')

      unless params[:section][:department].blank?
        @department = params[:section][:department]
        @sections = @sections.in_department(@department)
      end

      unless params[:section][:status].blank?
        @status = params[:section][:status]
        if @status == 'ACTIVE'
          @sections = @sections.not_canceled
        elsif @status == 'ALL'
          @sections
        else
          @sections = @sections.in_status(@status)
        end
      else
        @sections = @sections.not_canceled
      end

      unless params[:section][:level].blank?
        @section_level = params[:section][:level] if Section.level_code_list.include?(params[:section][:level])
        @sections = @sections.send(@section_level) if @section_level.present?
      end

      unless params[:section][:flagged].blank?
        @flagged_as = params[:section][:flagged]
        if Section.flagged_as_list.include?(@flagged_as)
          @sections = @sections.flagged_as?(@flagged_as)
        end
      end
    else
      @sections = @sections.not_canceled
    end
  end

  def ensure_admin!
    unless current_user.admin?
      redirect_to sections_path, notice: 'You do not have access to this page'
      return false
    end
  end

  def section_params
    allowed_params = [:owner, :term, :section_id, :department, :cross_list_group, :course_description, :section_number, :title, :credits, :level, :status, :enrollment_limit, :actual_enrollment, :cross_list_enrollment, :waitlist]
    allowed_params << :resolved_section if current_user.is_admin?
    params.require(:section).permit(allowed_params)
  end
end
