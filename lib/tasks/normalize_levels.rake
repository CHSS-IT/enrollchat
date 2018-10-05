namespace :normalize_data do
  include Rake::DSL

  task :levels => :environment do
    Section.all.each do |s|
      found = Section.level_list.find_index(s.level)
      if found.present?
        s.update(level: Section.level_code_list[found])
      else
        puts "NOT FOUND -- Skipped"
      end

    end
  end
end
