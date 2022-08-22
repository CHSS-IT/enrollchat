namespace :marketing_info do
  include Rake::DSL

  task :update => :environment do
    data_feed_uri = Setting.first.data_feed_uri
    if data_feed_uri.blank?
      puts "This task requires a full url in the data feed URI setting."
    else
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
          url = URI("#{data_feed_uri}?term=#{current_term}&course_code=#{course_code}")
          response = Net::HTTP.get(url)
          chssweb_sections = JSON.parse(response)

          puts chssweb_sections.size

          chssweb_sections.each do |chssweb_section|
            #### for each section in response
            #### find it in enrollchat
            section = Section.unscoped.where(section_id: chssweb_section['crn'].to_i, term: term).first
            puts "#{chssweb_section['id']} - #{section.present?}"
            if section.present?
              section.assign_attributes(chssweb_title: chssweb_section['title'], image_present: chssweb_section['has_image?'], description_present: chssweb_section['has_description?'], youtube_present: chssweb_section['has_youtube?'], instructor_name: chssweb_section['instructor_name'], second_instructor_name: chssweb_section['second_instructor_name'])
              section.second_instructor_name = nil if section.instructor_name == section.second_instructor_name
              #### if any of the marketing info has changed, update it
              section.save if section.changed?
            else
              puts "#{chssweb_section['crn']} not found in #{term}"
            end
          end
        end
      end
    end
  end
end
