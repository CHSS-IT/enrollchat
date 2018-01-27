class SectionsController < ApplicationController
  before_action :ensure_admin!, only: [:import, :delete_term]
  before_action :authenticate_user!
  before_action :filter, only: :index

  # GET /sections
  # GET /sections.json

  def index
    @updated_at = Section.maximum(:updated_at)
  end

  def show
    @sections = Section.find(params[:id])
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
          @section_level = params[:section][:level]
          if @section_level == 'Graduate - First'
            @sections = @sections.graduate_first
          elsif @section_level == 'Graduate - Advanced'
            @sections = @sections.graduate_advanced
          elsif @section_level == ('Undergraduate - Lower Division')
            @sections = @sections.undergraduate_lower
          elsif @section_level == ('Undergraduate - Upper Division')
            @sections = @sections.undergraduate_upper
          end
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
      params.require(:section).permit(:owner, :term, :section_id, :department, :cross_list_group, :course_description, :section_number, :title, :credits, :level, :status, :enrollment_limit, :actual_enrollment, :cross_list_enrollment, :waitlist)
    end
end
