require 'delivery_windows'

namespace :weekly_reports do
  include Rake::DSL
  include DeliveryWindows

  task :send_emails => :environment do
    email_delivery = Rails.configuration.email_delivery
    unless email_delivery == :off
      if (email_delivery == :scheduled && delivery_window == true) || email_delivery == :on
        if Date.today.wday == 4
          ReportWorker.perform_async()
        end
      end
    end
  end
end
