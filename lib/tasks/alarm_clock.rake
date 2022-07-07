namespace :alarm_clock do
  include Rake::DSL

  task :wakeup => :environment do
    require 'net/http'

    uri = URI.parse("https://#{ENV.fetch('ENROLLCHAT_HOST', nil)}")
    Net::HTTP.get(uri)
  end
end
