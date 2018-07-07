module ReportsHelper
  def version_date_strings
    @enrollments.collect { |x| x.created_at.strftime('%b %e') }.uniq.flatten
  end

  def waitlist_history
    @enrollments.group_by(&:created_at).map{ |x, y| y.inject(0){ |sum, i| sum + i.waitlist } }
  end

  def cross_list_enrollment_history
    @enrollments.group_by(&:created_at).map{ |x, y| y.inject(0){ |sum, i| sum + i.cross_list_enrollment } }
  end

  def actual_enrollment_history
    @enrollments.group_by(&:created_at).map{ |x, y| y.inject(0){ |sum, i| sum + i.actual_enrollment } }
  end

  def enrollment_limit_history
    @enrollments.group_by(&:created_at).map{ |x, y| y.inject(0){ |sum, i| sum + i.enrollment_limit } }
  end
end
