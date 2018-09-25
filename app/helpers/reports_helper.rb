module ReportsHelper
  def version_date_strings
    @enrollments.keys.to_json.html_safe
  end

  def waitlist_history
    @enrollments.map{ |x, y| [y.inject(0){ |sum, i| sum + i.waitlist }, x] }.collect { |z| z[0] }
  end

  def cross_list_enrollment_history
    @enrollments.map{ |x, y| [y.inject(0){ |sum, i| sum + i.cross_list_enrollment }, x] }.collect { |z| z[0] }
  end

  def actual_enrollment_history
    @enrollments.map{ |x, y| [y.inject(0){ |sum, i| sum + i.actual_enrollment }, x] }.collect { |z| z[0] }
  end

  def enrollment_limit_history
    @enrollments.map{ |x, y| [y.inject(0){ |sum, i| sum + i.enrollment_limit }, x] }.collect { |z| z[0] }
  end
end
