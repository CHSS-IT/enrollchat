namespace :weekly_reports do
  include Rake::DSL

  task :send_emails => :environment do
    if Date.today.wday == 4
      ReportWorker.perform_async()
    end
  end
end
