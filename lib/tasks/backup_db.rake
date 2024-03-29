namespace :backup_db do
  desc "Creates and saves a secondary backup of the production database to an external location. Schedule weekly."

  task :secondary => :environment do
    file_report = ReportAction::Report.new

    if Time.zone.today.wday == 4
      file_report.report_item("Secondary Backup","Backup Task Running","Secondary backup task called from #{Rails.env}.")
      if Rails.env.development?
        app_flag = "--app #{Rails.application.class.module_parent_name.downcase}"
        Bundler.with_unbundled_env do
          file_report.report_item("Secondary Backup","Download Progress","Creating backup of production database.")
          system("heroku pg:backups:capture #{app_flag}")
          file_report.report_item("Secondary Backup","Download Progress","Downloading latest dump of database locally.")
          system("heroku pg:backups:download -o latestbackup.sql #{app_flag}")
        end
      end
      if Rails.env.production?
        system('pg_dump -Fc $DATABASE_URL > latestbackup.sql')
        file_report.report_item("Secondary Backup","Download Progress","Creating backup of production database and saving locally.")
      end
      file_name = "#{ENV.fetch('FILE_BACKUP_NAME', nil)}_#{Time.zone.now.year}-#{Time.zone.now.month}-#{Time.zone.now.day}.sql"
      s3 = Aws::S3::Resource.new(region: ENV.fetch('AWS_DEFAULT_REGION', nil))
      bucket = s3.bucket(ENV.fetch("S3_BACKUP_BUCKET_NAME", nil))
      obj = s3.bucket(ENV.fetch("S3_BACKUP_BUCKET_NAME", nil)).object(file_name)
      obj.upload_file("latestbackup.sql")
      file_list = bucket.objects.sort_by(&:last_modified).collect(&:key)
      oldest_file_name = file_list.first
      file_count = bucket.objects.count
      all_files = bucket.objects
      if file_list.include?(file_name)
        file_report.report_item("Secondary Backup","Task Progress","Backup file #{file_name} saved to secondary backup location.")
      else
        file_report.report_item("Secondary Backup","Task Progress","There may have been a problem saving the secondary backup. Check backup location.")
      end
      if file_count > 20
        all_files.each do |file|
          if file.key.to_s == oldest_file_name
            file.delete
            file_report.report_item("Secondary Backup","Task Progress","Maximum number of backups reached. #{file.key} has been deleted.")
          end
        end
      end
      file_report.report_item("Secondary Backup","Task Progress","Removing local copy of database file.")
      system("rm latestbackup.sql")
      report_body = file_report.build_report("Secondary Backup")
      subject = "EnrollChat Secondary Backup Executed"
      CommentsMailer.generic(report_body.html_safe, subject, ENV.fetch("ENROLLCHAT_ADMIN_EMAIL", nil)).deliver! if file_report.has_messages?("Secondary Backup", "Backup Task Running")
    end
  end
end
