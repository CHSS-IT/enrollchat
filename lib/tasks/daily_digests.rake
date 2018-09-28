namespace :daily_digests do
  include Rake::DSL

  task :send_emails => :environment do
    DigestWorker.perform_async()
  end
end