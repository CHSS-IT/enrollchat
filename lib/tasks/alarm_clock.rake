namespace :alarm_clock do
  include Rake::DSL

  task :wakeup => :environment do
    require 'net/http'

    uri = URI.parse("https://#{ENV['ENROLLCHAT_HOST']}")
    Net::HTTP.get(uri)
  end
end
