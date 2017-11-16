class SectionsController < ApplicationController
  before_action :set_section, only: :show
  before_action :ensure_admin!, only: [:import, :delete_term]
  before_action :authenticate_user!
  before_action :filter, only: :index

  # GET /sections
  # GET /sections.json

  def index
    @sections = @sections.by_term(@term)
    @updated_at = Section.maximum(:updated_at)
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

  def delete_term
    @sections = Section.by_term(params[:term]).update_all(delete_at: DateTime.now().next_month)
    redirect_to sections_path, notice: "All sections and comments from term #{params[:term]} are marked for deletion."
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    def filter
      @sections = Section.all
      unless params[:section].blank?
        unless params[:section][:department].blank?
          @department = params[:section][:department]
          @sections = @sections.by_department(@department)
        end

        unless params[:section][:status].blank?
          @status = params[:section][:status]
          if @status == 'ACTIVE'
            @sections = @sections.not_canceled
          else
            @sections = @sections.by_status(@status)
          end
        end

        unless params[:section][:level].blank?
          @section_level = params[:section][:level]
          if @section_level == "Graduate - First"
            @sections = @sections.graduate_first
          elsif @section_level == "Graduate - Advanced"
            @sections = @sections.graduate_advanced
          elsif @section_level == ("Undergraduate - Lower Division")
            @sections = @sections.undergraduate_lower
          elsif @section_level == ("Undergraduate - Upper Division")
            @sections = @sections.undergraduate_upper
          end
        end

        unless params[:section][:enrollment_status].blank?
          @enrollment_status = params[:section][:enrollment_status]
          if @enrollment_status == 'Undergraduate over-enrolled'
            @sections = @sections.undergraduate_level.over_enrolled
          elsif @enrollment_status == 'Undergraudate under-enrolled'
            @sections = @sections.undergraduate_level.undergraduate_under_enrolled
          elsif @enrollment_status == 'Graduate over-enrolled'
            @sections = @sections.graduate_level.over_enrolled
          elsif @enrollment_status == 'Graduate under-enrolled'
            @sections = @sections.graduate_level.graduate_under_enrolled
          end
        end

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
