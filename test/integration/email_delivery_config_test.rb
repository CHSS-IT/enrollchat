require 'test_helper'
require 'sidekiq/testing'
require 'delivery_windows'
Sidekiq::Testing.fake!

class EmailDeliveryConfigTest < ActionDispatch::IntegrationTest
  include DeliveryWindows

  setup do
    Rake::Task.clear
    Sidekiq::Worker.clear_all
    Enrollchat::Application.load_tasks
  end

  teardown do
    Sidekiq::Worker.clear_all
    Rake::Task.clear
  end

  test "daily digest worker is performed if email delivery config is 'on'" do
    Rails.configuration.email_delivery = "on"
    Rake::Task['daily_digests:send_emails'].invoke
    assert_equal 1, DigestWorker.jobs.size
  end

  test "daily digest worker is not performed if email delivery config is 'off'" do
    Rails.application.config.email_delivery = "off"
    Rake::Task['daily_digests:send_emails'].invoke
    assert_equal 0, DigestWorker.jobs.size
  end

  test "daily digest worker is not performed if email delivery config is 'scheduled' and delivery_window is false" do
    Rails.application.config.email_delivery = "scheduled"
    travel_to Time.zone.local(2018, 10, 15, 1, 4, 44) do
      Rake::Task['daily_digests:send_emails'].invoke
      assert_equal 0, DigestWorker.jobs.size
    end
  end

  test "daily digest worker is performed if email delivery config is 'scheduled' and delivery_window is true" do
    Rails.application.config.email_delivery = "scheduled"
    travel_to Time.zone.local(2018, 4, 15, 1, 4, 44) do
      Rake::Task['daily_digests:send_emails'].invoke
      assert_equal 1, DigestWorker.jobs.size
    end
  end

  test "report worker is not performed if email delivery config is 'off'" do
    Rails.application.config.email_delivery = "off"
    travel_to Time.zone.local(2018, 8, 16, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      assert_equal 0, ReportWorker.jobs.size
    end
  end

  test "report worker is performed if email delivery config is 'on' and it is Thursday" do
    Rails.application.config.email_delivery = "on"
    travel_to Time.zone.local(2018, 8, 16, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      assert_equal 1, ReportWorker.jobs.size
    end
  end

  test "report worker is not performed if email delivery config is 'on' and it is not Thursday" do
    Rails.application.config.email_delivery = "on"
    travel_to Time.zone.local(2018, 10, 15, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      assert_equal 0, ReportWorker.jobs.size
    end
  end

  test "report worker is performed if email delivery config is 'scheduled', it is Thursday and delivery window is true" do
    Rails.application.config.email_delivery = "scheduled"
    travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      assert_equal 1, ReportWorker.jobs.size
    end
  end

  test "report worker is not performed if email delivery config is 'scheduled' and delivery window is false" do
    Rails.application.config.email_delivery = "scheduled"
    travel_to Time.zone.local(2018, 10, 18, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      assert_equal 0, ReportWorker.jobs.size
    end
  end
end
