namespace :alarm_clock do
  include Rake::DSL

  task :wakeup => :environment do
    require 'net/http'

    uri = URI.parse('https://enrollchat.herokuapp.com')
    Net::HTTP.get(uri)
  end
end
