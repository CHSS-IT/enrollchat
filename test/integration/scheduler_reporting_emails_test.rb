require 'test_helper'

class SchedulerReportingEmailsTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  setup do
    Rake::Task.clear
    Enrollchat::Application.load_tasks
  end

  teardown do
    Rake::Task.clear
  end

  # schedule old term purge rake task
  test "schedule old term purge email is generated" do
    travel_to Time.zone.local(2022, 1, 10, 10, 4, 44) do
      assert_emails 1 do
        Rake::Task['scheduler:schedule_old_term_purge'].invoke
      end
    end
  end

  test "schedule old term purge email content" do
    travel_to Time.zone.local(2022, 1, 10, 10, 4, 44) do
      Rake::Task['scheduler:schedule_old_term_purge'].invoke
    end
    email = ActionMailer::Base.deliveries.last
    assert_equal ["no-reply@example.com"], email.from
    assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.to
    assert_equal 'Terms Marked for Deletion (Triggered in test)', email.subject
    assert email.body.to_s.include?("<h1>Terms marked for deletion</h1><p>201810</p><p>All sections from these terms will be removed from the system in 30 days.</p>")
  end
end
