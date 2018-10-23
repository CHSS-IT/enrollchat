namespace :import do
  include Rake::DSL

  # TODO: Code smell. Gemify reporting process.
  def initialize
    @report = {}
  end

  task :retrieve_files => :environment do
    require 'net/ssh'
    require 'net/sftp'

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
              report_action('Current File', 'Download', "Downloaded #{current_file.name}.")
            else
              report_action('Current File', 'Download', "Not eligible for download: #{current_file.name}.")
            end
          end

          if current_files.present?
            report_action('Current File', 'Backups', "Backing up files.")
            current_files.each do |file|
              sftp.rename!("#{remote}/#{file.name}", "#{remote}/backup/#{file.name}") #if Rails.env.production? && 1 == 2 # back up today's files # TEMPORARILY DISABLING REMOVAL; TODO: Reactivate when feed is working
              report_action('Current File', 'Download', "Moved #{file.name}.")
            end
          end

          if @uploader.present?
            ActionCable.server.broadcast 'room_channel',
                                         message: "<a href='/sections' class='dropdown-item'>Registration data import in process.</a>"
            ImportWorker.perform_async(@uploader.url.to_s)
            report_action('Current File', 'Import', "Import queued.")
          else
            report_action('Current File', 'Import', "Import not queued.")
          end

        else
          report_action('Current File', 'Download', "No files present.")
        end
      end
    end
    send_report if @report.present?
  end

  # TODO: Code smell. Gemify reporting process.
  def send_report
    email = ''
    subject = "Import Executed"
    subject += " (TRIGGERED IN #{Rails.env})" if Rails.env != 'production'
    @report.each do |target,groups|
      groups.each do |group,messages|
        email = email + "<h1>#{group.capitalize}</h1>"
        messages.uniq.sort.each do |message|
          email = email + message + '<br />'
        end
      end
    end
    CommentsMailer.generic(email.html_safe, "Import Executed", ENV['ENROLLCHAT_ADMIN_EMAIL']).deliver!
  end



  # TODO: Code smell. Gemify reporting process.
  def report_action(target, group, message)
    @report[target] ||= {}
    @report[target][group] ||= []
    @report[target][group] << message
  end

end
