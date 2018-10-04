require 'delivery_windows'

namespace :daily_digests do
  include Rake::DSL
  include DeliveryWindows

  task :send_emails => :environment do
    unless Rails.configuration.email_delivery == "off"
      if (Rails.configuration.email_delivery == "scheduled" && delivery_window == true) || Rails.configuration.email_delivery == "on"
        DigestWorker.perform_async()
      end
    end
  end
end
