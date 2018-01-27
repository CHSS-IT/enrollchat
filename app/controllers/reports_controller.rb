class ReportsController < ApplicationController
  def index
    @sections = Section.in_term(@term).order(:department)
    @max_date = @sections.in_term(@term).maximum(:updated_at)
    @not_canceled = @sections.in_term(@term).not_canceled.size
    @canceled = @sections.in_term(@term).canceled.size
    @full = @sections.in_term(@term).full.size
    @under_enrolled = @sections.in_term(@term).under_enrolled.size
    @over_enrolled = @sections.in_term(@term).over_enrolled.size
    @sections = @sections.in_term(@term).group_by { |s| s.department}




  end
end
