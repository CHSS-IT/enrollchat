namespace :import do
  include Rake::DSL

  task :retrieve_files => :environment do
    # require 'net/ssh'
    # require 'net/sftp'
    require 'aws-sdk'

    Rake::Task['alarm_clock:wakeup'].execute

    file_report = ReportAction::Report.new

    s3 = Aws::S3::Resource.new(region: ENV["AWS_DEFAULT_REGION"])
    bucket = s3.bucket(ENV["S3_JIJU_BUCKET_NAME"])
    current_files = bucket.objects
    file_report.report_item('Import','Overall',"Download running.")
    if current_files.present?
      current_files.each do |file|
        if file.key.include?("BACKUP-") && Rails.env.production?
          backup_file = file
          backup_file.delete
          file_report.report_item('Import','Cleanup', "#{backup_file.key} deleted.")
        elsif file.key.include?("BACKUP-") && !Rails.env.production?
          file_report.report_item('Import', 'Cleanup', "Backups not cleared since this was called from #{Rails.env}.")
        else
          file_report.report_item('Import','Cleanup', "There were no old backup files to remove.")
        end
      end
      current_files.each do |file|
        if file.key.include?(ENV["ENROLLMENT_FILE_NAME"])
          current_file = file
          new_name = current_file.key.to_s
          file_report.report_item('Import', 'Download', "Looking at current file: #{new_name}.")
          current_file.get(response_target: "#{Rails.root}/tmp/#{new_name}")
          if Rails.env.production?
            @uploader = FeedUploader.new
            file = File.open("#{Rails.root}/tmp/#{new_name}", 'rb')
            @uploader.store!(file)
            file_report.report_item('Import', 'Download', "Stored #{new_name} at #{@uploader.url.to_s}.")
            current_file.copy_to(bucket.object("BACKUP-#{current_file.key}"))
            current_file.delete
            file_report.report_item('Import', 'Download', "Moved #{new_name}.")
          else
            file_report.report_item('Import', 'Download', "File not stored to uploader since this was called from #{Rails.env}.")
            file_report.report_item('Import', 'Download', "File not moved to backup since this was called from #{Rails.env}.")
            File.delete("#{Rails.root}/tmp/#{new_name}")
            file_report.report_item('Import', 'Download', "Local copy of download file removed from #{Rails.env}.")
          end
        else
          file_report.report_item('Import', 'Download', "No files eligible for download.")
        end
      end
    else
      file_report.report_item('Import', 'Download', "No files present.")
    end
    email = file_report.build_report('Import')
    subject = "Import Executed"
    CommentsMailer.generic(email.html_safe, subject, ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver! if file_report.has_messages?('Import', 'Overall')
  end

  task :local_download => :environment do
    require 'aws-sdk'

    s3 = Aws::S3::Resource.new(region: ENV["AWS_DEFAULT_REGION"])
    bucket = s3.bucket(ENV["S3_JIJU_BUCKET_NAME"])
    current_files = bucket.objects
    file_count = 0
    if current_files.present? && !Rails.env.production?
      current_files.each do |file|
        if file.key.include?(ENV["ENROLLMENT_FILE_NAME"]) || file.key.include?("BACKUP-")
          new_name = file.key.to_s
          file.get(response_target: "#{Rails.root}/doc/#{new_name}")
          file_count += 1
        end
      end
    end
    if file_count == 0
      puts "Import file not present or task was called in production."
    else
      puts "#{ActionController::Base.helpers.pluralize(file_count, 'file')} downloaded."
    end
  end
end
