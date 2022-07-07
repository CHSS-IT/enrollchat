namespace :update_db do
  desc "Creates a backup of the production database and uses it to update the local development database. Requires Heroku CLI."

  task :dev => :environment do
    if Rails.env.development?
      app_flag = "--app #{Rails.application.class.module_parent_name.downcase}"
      Bundler.with_unbundled_env do
        puts "Creating backup of production database"
        system("heroku pg:backups:capture #{app_flag}")
        puts "Downloading latest dump of database locally."
        system("heroku pg:backups:download -o latest.dump #{app_flag}")
      end
      puts "Working off local copy of database. Updating development..."
      system("pg_restore --verbose #{ENV.fetch('DATABASE_COMMAND', nil)} latest.dump")
      puts "Complete. Removing local copy of database file."
      File.delete(Rails.root.join("latest.dump"))
    end
  end
end
