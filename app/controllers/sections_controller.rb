class SectionsController < ApplicationController
  before_action :set_term, only: :index
  before_action :set_section, only: :show
  before_action :ensure_admin!, only: :import

  # GET /sections
  # GET /sections.json
  def index
    @sections = Section.where(term: @term)
  end

  def import
    if params[:file].nil?
      flash[:alert] = "Upload attempted but no file was attached!"
    else
      ActionCable.server.broadcast 'room_channel',
                                   body:  "Registration data import in process.",
                                   section_name: "Alert",
                                   user: "System"

      feed = params[:file]

      uploader = FeedUploader.new
      uploader.store!(feed)


      # File.delete(Rails.root.join('tmp', params[:file].original_filename)) if File.exists?(Rails.root.join('tmp', params[:file].original_filename))
      # File.open(Rails.root.join('tmp', params[:file].original_filename), 'wb') do |file|
      #   file.write(params[:file].read)
      # end
      #
      # filepath = Rails.root.join('tmp', params[:file].original_filename)
      #
      ImportWorker.perform_async("#{uploader.url}", current_user.id)

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

  def set_term
    @term = Section.maximum(:term)
  end

  def ensure_admin!
    unless current_user.admin?
      redirect_to root_path, notice: 'You do not have access to this page'
      return false
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:owner, :term, :section_id, :department, :cross_list_group, :course_description, :section_number, :title, :credits, :level, :status, :enrollment_limit, :actual_enrollment, :cross_list_enrollment, :waitlist)
    end
end
