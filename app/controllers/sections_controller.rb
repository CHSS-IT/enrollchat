class SectionsController < ApplicationController
  before_action :set_term, only: :index
  before_action :set_section, only: :show

  # GET /sections
  # GET /sections.json
  def index
    @sections = Section.where(term: @term)
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:owner, :term, :section_id, :department, :cross_list_group, :course_description, :section_number, :title, :credits, :level, :status, :enrollment_limit, :actual_enrollment, :cross_list_enrollment, :waitlist)
    end
end
