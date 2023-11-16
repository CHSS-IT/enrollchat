class SectionsController < ApplicationController
  before_action :filter, only: :index
  before_action :authenticate_user!
  before_action :ensure_admin!, only: [:delete_term, :toggle_resolved_section]

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
    @section.broadcast_update_later_to("resolved_section_indicator", target: "resolved_#{@section.id}", partial: "sections/toggle_resolved_section", locals: { section: @section })
    respond_to do |format|
      format.turbo_stream
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
        if @section_level.present?
          logger.debug("#{@section_level}")
          if @section_level == 'uuall'
            @sections = @sections.all_undergraduate
          elsif @section_level == 'ugall'
            @sections = @sections.all_graduate
          else
            @sections = @sections.in_level(@section_level)
          end
        end
      end

      unless params[:section][:modality].blank?
        logger.debug("MODALITY SELECTED: #{params[:section][:modality]}")
        @modality = params[:section][:modality] if Section.modality_list.include?(params[:section][:modality])
        @sections = @sections.send(@modality) if @modality.present?
      end

      unless params[:section][:flagged].blank?
        @flagged_as = params[:section][:flagged]
        case @flagged_as
        when 'waitlisted'
          @sections = @sections.all_waitlists
        when 'long-waitlist', 'under-enrolled'
          @sections = @sections.flagged_as?(@flagged_as)
        end
      end

    else
      @sections = @sections.not_canceled
    end
  end

  def section_params
    allowed_params = [:owner, :term, :section_id, :department, :cross_list_group, :course_description, :section_number, :title, :credits, :level, :status, :enrollment_limit, :actual_enrollment, :cross_list_enrollment, :waitlist]
    allowed_params << :resolved_section if current_user.is_admin?
    params.require(:section).permit(allowed_params)
  end
end
