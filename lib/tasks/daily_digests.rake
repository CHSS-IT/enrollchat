require 'delivery_windows'

namespace :daily_digests do
  include Rake::DSL
  include DeliveryWindows

  task :send_emails => :environment do
    email_delivery = Setting.first.email_delivery
    unless email_delivery == "off"
      if (email_delivery == "scheduled" && delivery_window == true) || email_delivery == "on"
        DigestWorker.perform_async()
      end
    end
  end
end
