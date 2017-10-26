class ReportsController < ApplicationController
  def index
    @sections = Section.by_term(@term).order(:department)
    @max_date = @sections.maximum(:updated_at)
    @not_canceled = @sections.not_canceled.size
    @canceled = @sections.canceled.size
    @full = @sections.full.size
    @under_enrolled = @sections.under_enrolled.size
    @over_enrolled = @sections.over_enrolled.size
    @sections = @sections.group_by { |s| s.department}




  end
end
