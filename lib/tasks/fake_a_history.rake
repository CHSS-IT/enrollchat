namespace :fake_a_history do

  include Rake::DSL

  task :now => :environment do
    s = Section.last
    1.upto 30 do |day|
      s.enrollments.build(department: s.department, enrollment_limit: 33, actual_enrollment: rand(0..30), cross_list_enrollment: rand(0..30), waitlist: rand(0..30), created_at: "2018/6/#{day}", updated_at: "2018/6/#{day}")
    end
    s.save!
    puts "History faked for section #{s.id}"
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