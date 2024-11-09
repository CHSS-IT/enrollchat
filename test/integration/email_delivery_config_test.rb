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
    @settings = settings(:one)
  end

  teardown do
    Sidekiq::Worker.clear_all
    Rake::Task.clear
  end

  test "daily digest worker is performed if email delivery config is 'on'" do
    @settings.update(email_delivery: "on")
    Rake::Task['daily_digests:send_emails'].invoke
    assert_equal 1, DigestWorker.jobs.size
  end

  test "daily digest worker is not performed if email delivery config is 'off'" do
    @settings.update(email_delivery: "off")
    Rake::Task['daily_digests:send_emails'].invoke
    assert_equal 0, DigestWorker.jobs.size
  end

  test "daily digest worker is not performed if email delivery config is 'scheduled' and fall delivery_window has ended" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 10, 15, 1, 4, 44) do
        Rake::Task['daily_digests:send_emails'].invoke
        assert_equal 0, DigestWorker.jobs.size
      end
    end
  end

  test "daily digest worker is not performed if email delivery config is 'scheduled' and spring delivery_window has ended" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 2, 13, 1, 4, 44) do
        Rake::Task['daily_digests:send_emails'].invoke
        assert_equal 0, DigestWorker.jobs.size
      end
    end
  end

  test "daily digest worker is performed if email delivery config is 'scheduled' and fall delivery_window is true" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 4, 15, 1, 4, 44) do
        Rake::Task['daily_digests:send_emails'].invoke
        assert_equal 1, DigestWorker.jobs.size
      end
    end
  end

  test "daily digest worker is performed if email delivery config is 'scheduled' and spring delivery_window is true" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 1, 15, 1, 4, 44) do
        Rake::Task['daily_digests:send_emails'].invoke
        assert_equal 1, DigestWorker.jobs.size
      end
    end
  end

  test "report worker is not performed if email delivery config is 'off'" do
    @settings.update(email_delivery: "off")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 8, 16, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        assert_equal 0, ReportWorker.jobs.size
      end
    end
  end

  test "report worker is performed if email delivery config is 'on' and it is Thursday" do
    @settings.update(email_delivery: "on")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 8, 16, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        assert_equal 1, ReportWorker.jobs.size
      end
    end
  end

  test "report worker is not performed if email delivery config is 'on' and it is not Thursday" do
    @settings.update(email_delivery: "on")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 10, 15, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        assert_equal 0, ReportWorker.jobs.size
      end
    end
  end

  test "report worker is performed if email delivery config is 'scheduled', it is Thursday and spring delivery window is true" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 1, 18, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        assert_equal 1, ReportWorker.jobs.size
      end
    end
  end

  test "report worker is performed if email delivery config is 'scheduled', it is Thursday and fall delivery window is true" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 4, 19, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        assert_equal 1, ReportWorker.jobs.size
      end
    end
  end

  test "report worker is not performed if email delivery config is 'scheduled', it is Thursday and fall delivery window has ended" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 10, 18, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        assert_equal 0, ReportWorker.jobs.size
      end
    end
  end

  test "report worker is not performed if email delivery config is 'scheduled', it is Thursday and spring delivery window has ended" do
    @settings.update(email_delivery: "scheduled")
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 2, 15, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        assert_equal 0, ReportWorker.jobs.size
      end
    end
  end
end
