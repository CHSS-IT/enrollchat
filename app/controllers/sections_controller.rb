class SectionsController < ApplicationController
  before_action :set_section, only: :show
  before_action :ensure_admin!, only: :import
  before_action :authenticate_user!
  before_action :set_department, only: :index

  # GET /sections
  # GET /sections.json

  def index
    if params[:section] && @department.present?
      @sections = Section.by_term(@term).by_department(@department)
    else
      @sections = Section.by_term(@term)
    end
    @updated_at = @sections.maximum(:updated_at)
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

      ImportWorker.perform_async("#{uploader.url}")

    end
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    def set_department
      if params[:section].present?
        logger.debug("Department param present.")
        @department = params[:section][:department]
      else
        logger.debug("Setting department to ALL")
        @department = 'ALL'
      end
    end

    def ensure_admin!
      unless current_user.admin?
        redirect_to sections_path, notice: 'You do not have access to this page'
        return false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:owner, :term, :section_id, :department, :cross_list_group, :course_description, :section_number, :title, :credits, :level, :status, :enrollment_limit, :actual_enrollment, :cross_list_enrollment, :waitlist)
    end
end
