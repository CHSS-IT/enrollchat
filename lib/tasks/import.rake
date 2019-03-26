namespace :import do
  include Rake::DSL

  task :retrieve_files => :environment do
    require 'net/ssh'
    require 'net/sftp'

    Rake::Task['alarm_clock:wakeup'].execute

    file_report = ReportAction::Report.new

    remote = ENV["ENROLLCHAT_REMOTE_DIR"]
    Net::SSH.start(ENV["ENROLLCHAT_REMOTE"], ENV["ENROLLCHAT_REMOTE_USER"], password: ENV["ENROLLCHAT_REMOTE_PASS"]) do |ssh|
      ssh.sftp.connect do |sftp|
        current_files = sftp.dir.glob(remote,"*.csv").sort_by(&:name)
        current_file = current_files.last
        backup = sftp.dir.glob("#{remote}/backup/","*.csv")
        file_report.report_item('Import','Overall',"Download running.")
        if current_files.present?
          # only remove backup files if called from production
          if backup.present? && Rails.env.production?
            backup.each do |file| # Keeping the glob so we clean up if we miss a day
              sftp.remove!("#{remote}/backup/#{file.name}") do |response| # remove backup of previous day's files
                p response
              end
              file_report.report_item('Import','Cleanup', "#{file.name} deleted.")
            end
          elsif !Rails.env.production?
            file_report.report_item('Import', 'Cleanup', "Backups not cleared since this was called from #{Rails.env}.")
          else
            file_report.report_item('Import','Cleanup', "There were no old backup files to remove.")
          end

          if current_file.present? && Rails.env.production?
            file_report.report_item('Import', 'Download', "Looking at current file: #{current_file.name}.")
            if current_file.name.include?(".csv")
              new_name = current_file.name.to_s
              sftp.download!("#{remote}/#{current_file.name}", "#{Rails.root}/tmp/#{new_name}")
              @uploader = FeedUploader.new
              file = File.open("#{Rails.root}/tmp/#{new_name}", 'rb')
              @uploader.store!(file)
              file_report.report_item('Import', 'Download', "Stored #{current_file.name} at #{@uploader.url.to_s}.")
            else
              file_report.report_item('Import', 'Download', "Not eligible for download: #{current_file.name}.")
            end
          elsif !Rails.env.production?
            file_report.report_item('Import', 'Download', "File not stored to uploader since this was called from #{Rails.env}.")
          end

          if current_files.present? && Rails.env.production?
            file_report.report_item('Import', 'Backups', "Backing up files.")
            current_files.each do |file|
              sftp.rename!("#{remote}/#{file.name}", "#{remote}/backup/#{file.name}") # if Rails.env.production? && 1 == 2 # back up today's files # TEMPORARILY DISABLING REMOVAL; TODO: Reactivate when feed is working
              file_report.report_item('Import', 'Download', "Moved #{file.name}.")
            end
          elsif !Rails.env.production?
            file_report.report_item('Import', 'Download', "File not moved to backup since this was called from #{Rails.env}.")
          end

        else
          file_report.report_item('Import', 'Download', "No files present.")
        end
      end
    end
    email = file_report.build_report('Import')
    subject = "Import Executed"
    CommentsMailer.generic(email.html_safe, subject, ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver! if file_report.has_messages?('Import', 'Overall')
  end
end
