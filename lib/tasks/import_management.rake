namespace :import_management do
  include Rake::DSL

  task :move_file => :environment do
    require 'net/ssh'
    require 'net/sftp'

    remote = ENV["ENROLLCHAT_REMOTE_DIR"]
    remote_home = ENV["ENROLLCHAT_REMOTE_HOME_DIR"]
    file_count = 0
    Net::SSH.start(ENV["ENROLLCHAT_REMOTE"], ENV["ENROLLCHAT_REMOTE_USER"], password: ENV["ENROLLCHAT_REMOTE_PASS"]) do |ssh|
      ssh.sftp.connect do |sftp|
        sftp.dir.glob(remote_home,"*.csv") do |file|
          if file.name.include?("szpcsch_crse") && Rails.env.production?
            sftp.rename("#{remote_home}/#{file.name}", "#{remote}/#{file.name}")
            file_count += 1
          end
        end
      end
    end
    if file_count == 0
      puts "Import file not present."
    else
      puts "#{file_count} file moved to EnrollChat directory."
    end
  end

  task :download_files => :environment do
    require 'net/ssh'
    require 'net/sftp'

    remote = ENV["ENROLLCHAT_REMOTE_DIR"]
    file_count = 0
    Net::SSH.start(ENV["ENROLLCHAT_REMOTE"], ENV["ENROLLCHAT_REMOTE_USER"], password: ENV["ENROLLCHAT_REMOTE_PASS"]) do |ssh|
      ssh.sftp.connect do |sftp|
        sftp.dir.glob(remote,"*.csv") do |file|
          if file.name.include?("szpcsch_crse") && Rails.env != 'production'
            new_name = "#{file.name.split("_")[0]}_#{file.name.split("_")[1]}.csv"
            sftp.download!("#{remote}/#{file.name}", "#{Rails.root}/doc/#{new_name}")
            file_count += 1
          end
        end
      end
    end
    if file_count == 0
      puts "Import file not present."
    else
      puts "#{ActionController::Base.helpers.pluralize(file_count, 'file')} downloaded."
    end
  end

  task :download_backups => :environment do
    require 'net/ssh'
    require 'net/sftp'

    remote_backup = ENV["ENROLLCHAT_REMOTE_BACKUP_DIR"]
    file_count = 0
    Net::SSH.start(ENV["ENROLLCHAT_REMOTE"], ENV["ENROLLCHAT_REMOTE_USER"], password: ENV["ENROLLCHAT_REMOTE_PASS"]) do |ssh|
      ssh.sftp.connect do |sftp|
        sftp.dir.glob(remote_backup,"*.csv") do |file|
          if file.name.include?("szpcsch_crse") && Rails.env != 'production'
            new_name = "#{file.name.split("_")[0]}_#{file.name.split("_")[1]}.csv"
            sftp.download!("#{remote_backup}/#{file.name}", "#{Rails.root}/doc/#{new_name}")
            file_count += 1
          end
        end
      end
    end
    if file_count == 0
      puts "Import backup file not present."
    else
      puts "#{ActionController::Base.helpers.pluralize(file_count, 'file')} downloaded."
    end
  end

  task :cleanup => :environment do
    # Clear backup directory
    # Move current file(s) to backup directory
  end
end
