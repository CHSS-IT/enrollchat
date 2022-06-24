namespace :marketing_info do
  include Rake::DSL

  task :update => :environment do

    # considering the time this consumes, once it's functioning it needs to go into a worker and be run in the background

    require 'open-uri'
    puts "Current term setting = #{@current_term}"
    # determine relevant semesters - Can I presume the current term setting exists? If so, current term and all future terms that are present
    current_term = Setting.first.current_term

    terms = Section.upcoming_terms(current_term)
    puts "Current term: #{current_term}"
    puts terms
    ## for each relevant term
    terms.each do |term|
      ## gather course codes
      course_codes = Section.course_codes_in_term(current_term)
      puts "Course codes: #{course_codes}"
      course_codes.each do |course_code|
        ### for each course code
        puts "Looking up #{course_code} in #{current_term}"
        ### send request to chssweb for that course code for the relevant semester

        # require 'nokogiri'
        url = URI("https://chssweb.gmu.edu/course_sections/marketing_state.json?term=#{current_term}&course_code=#{course_code}")
        response = Net::HTTP.get(url)
        chssweb_sections = JSON.parse(response)

        puts chssweb_sections.size

        chssweb_sections.each do |chssweb_section|
          #### for each section in response
          #### find it in enrollchat
          section = Section.unscoped.where(section_id: chssweb_section['crn'].to_i, term: term)
          puts "#{chssweb_section['id']} - #{section.present?}"
          #### if any of the marketing info has changed, update it
        end
      end
    end
  end
end