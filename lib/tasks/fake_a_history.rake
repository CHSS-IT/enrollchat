namespace :fake_a_history do

  include Rake::DSL

  task :now => :environment do
    sections = Section.in_term('201870').in_department('PSYC')
    sections.each do |section|
      fake_history(section)
    end
  end

  def fake_history(s)
    s.enrollments.build(department: s.department, term: s.term, enrollment_limit: 25, actual_enrollment: rand(0..15), cross_list_enrollment: rand(0..15), waitlist: rand(0..15), created_at: "2018/6/1", updated_at: "2018/6/1")
    2.upto 30 do |day|
      s.enrollments.build(department: s.department, term: s.term, enrollment_limit: 25, actual_enrollment: fun_random(s.actual_enrollment, -5, 10), cross_list_enrollment: fun_random(s.cross_list_enrollment, -2, 2), waitlist: fun_random(s.waitlist, -2, 2), created_at: "2018/6/#{day}", updated_at: "2018/6/#{day}")
    end
    s.save!
    puts "History faked for section #{s.id}"
  end
  
  def fun_random(value, start_num, end_num)
    result = value > end_num ? value + rand(start_num..end_num) : value + rand(0..end_num)
    result
  end

  task :clear => :environment do
    Enrollment.delete_all
    puts "Destroyed all enrollments."
  end

  task :clear_all => :environment do
    Section.destroy_all
    puts "Destroyed all sections and enrollments."
  end

end