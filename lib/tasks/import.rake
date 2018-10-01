namespace :import do
  include Rake::DSL

  task :retrieve_files => :environment do
    require 'net/ssh'
    require 'net/sftp'

    remote = ENV["ENROLLCHAT_REMOTE_DIR"]
    Net::SSH.start(ENV["ENROLLCHAT_REMOTE"], ENV["ENROLLCHAT_REMOTE_USER"], password: ENV["ENROLLCHAT_REMOTE_PASS"]) do |ssh|
      ssh.sftp.connect do |sftp|
        current_files = sftp.dir.glob(remote,"*.csv")
        backup = sftp.dir.glob("#{remote}/backup/","*.csv")
        puts current_files
        puts Rails.env
        puts "Download running."
        if current_files.present?
          # only remove backup files if called from production
          if backup.present? && Rails.env.production? && 1 == 2 # TEMPORARILY DISABLING REMOVAL; TODO: Reactivate when feed is working
            sftp.dir.glob("#{remote}/backup/","*.csv") do |file| # There's only one file so we don't really need this
              if file.name.include?(".csv")
                sftp.remove("#{remote}/backup/#{file.name}") # remove backup of previous day's files
              end
            end
            puts "Removed up old files."
          else
            puts "There were no old files to remove"
          end
          sftp.dir.glob(remote,"*.csv") do |file|
            puts "Looking at #{file.name}"
            if file.name.include?(".csv")
              puts "Grabbing."
              new_name = file.name.to_s
              sftp.download!("#{remote}/#{file.name}", "#{Rails.root}/tmp/#{new_name}")
              @uploader = FeedUploader.new
              file = File.open("#{Rails.root}/tmp/#{new_name}", 'rb')
              @uploader.store!(file)
              sftp.rename("#{remote}/#{file.name}", "#{remote}/backup/#{file.name}") if Rails.env.production? && 1 == 2 # back up today's files # TEMPORARILY DISABLING REMOVAL; TODO: Reactivate when feed is working
            end
          end
          puts "Downloaded new files."
          puts "Moved files to the backup directory." if Rails.env.production?
          ActionCable.server.broadcast 'room_channel',
                                       message: "<a href='/sections' class='dropdown-item'>Registration data import in process.</a>"
          path = "#{Rails.root}/tmp/SemesterEnrollments.csv"

          puts @uploader.url

          ImportWorker.perform_async(@uploader.url.to_s)

        else
          puts "No files present."
        end
      end
    end
  end

  task :bulletproof => :environment do
    puts "Start"
    Dir.glob("#{Rails.root}/doc/*.csv").each do |f|
      text = File.read(f)
      old_text = File.read(f)
      new_contents = text.gsub(/(?<!^)(?<!,)"(?!,|\R)/, "'")
      # To merely print the contents of the file, use:
      puts new_contents

      # To write changes to the file, use:
      File.open(f, "w") { |file| file.write new_contents }

      if new_contents != old_text
        report_action(chss,"CSV Correction","Bulletproof task made changes to #{f}.")
      end
    end
    puts "Finish"
  end
end
