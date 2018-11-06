require 'reporting'

namespace :import do
  include Rake::DSL

  # TODO: Code smell. Gemify reporting process.
  def initialize
    @report = {}
    @subject = "Import Executed"
  end

  task :retrieve_files => :environment do
    require 'net/ssh'
    require 'net/sftp'
    include Reporting

    initialize

    remote = ENV["ENROLLCHAT_REMOTE_DIR"]
    Net::SSH.start(ENV["ENROLLCHAT_REMOTE"], ENV["ENROLLCHAT_REMOTE_USER"], password: ENV["ENROLLCHAT_REMOTE_PASS"]) do |ssh|
      ssh.sftp.connect do |sftp|
        current_files = sftp.dir.glob(remote,"*.csv").sort_by(&:name)
        current_file = current_files.last
        backup = sftp.dir.glob("#{remote}/backup/","*.csv")
        report_action('Import','Overall',"Download running.")
        if current_files.present?
          # only remove backup files if called from production
          if backup.present? && Rails.env.production?
            backup.each do |file| # Keeping the glob so we clean up if we miss a day
              sftp.remove!("#{remote}/backup/#{file.name}") do |response| # remove backup of previous day's files
                p response
              end
              report_action('Backups','Cleanup', "#{file.name} deleted.")
            end
          elsif Rails.env.production?
            report_action('Current File', 'Cleanup', "Backups not cleared since this was called from #{Rails.env}.")
          else
            report_action('Backups','Cleanup', "There were no old backup files to remove.")
          end

          if current_file.present?
            report_action('Current File', 'Download', "Looking at current file: #{current_file.name}.")
            if current_file.name.include?(".csv")
              new_name = current_file.name.to_s
              sftp.download!("#{remote}/#{current_file.name}", "#{Rails.root}/tmp/#{new_name}")
              @uploader = FeedUploader.new
              file = File.open("#{Rails.root}/tmp/#{new_name}", 'rb')
              @uploader.store!(file)
              report_action('Current File', 'Download', "Stored #{current_file.name} at #{@uploader.url.to_s}.")
            else
              report_action('Current File', 'Download', "Not eligible for download: #{current_file.name}.")
            end
          end

          if current_files.present? && Rails.env.production?
            report_action('Current File', 'Backups', "Backing up files.")
            current_files.each do |file|
              sftp.rename!("#{remote}/#{file.name}", "#{remote}/backup/#{file.name}") # if Rails.env.production? && 1 == 2 # back up today's files # TEMPORARILY DISABLING REMOVAL; TODO: Reactivate when feed is working
              report_action('Current File', 'Download', "Moved #{file.name}.")
            end
          elsif !Rails.env.production?
            report_action('Current File', 'Download', "File not moved to backup since this was called from #{Rails.env}.")
          end

        else
          report_action('Current File', 'Download', "No files present.")
        end
      end
    end
    send_report if @report.present?
  end
end
