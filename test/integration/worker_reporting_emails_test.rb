require 'test_helper'

class WorkerReportingEmailsTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  setup do
    Rake::Task.clear
    Sidekiq::Worker.clear_all
    Enrollchat::Application.load_tasks
  end

  teardown do
    Sidekiq::Worker.clear_all
    Rake::Task.clear
  end

  test "Weekly report emails is generated" do
    travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      Sidekiq::Worker.drain_all
      assert_emails User.wanting_report.count + 1
    end
  end

  test "Weekly report executed email content" do
    recipient = users(:one)
    recipient_two = users(:two)
    recipient_three = users(:three)
    travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      Sidekiq::Worker.drain_all
      email = ActionMailer::Base.deliveries.last
      assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.from
      assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.to
      assert_equal 'EnrollChat Report Task Executed (Triggered in test)', email.subject
      assert email.body.to_s.include?("<h1>EnrollChat Weekly Report Sent</h1>")
      assert email.body.to_s.include?("<p>Reports sent to:</p>")
      assert email.body.to_s.include?("<ul><li>#{recipient.full_name} (#{recipient.email})</li><li>#{recipient_two.full_name} (#{recipient_two.email})</li><li>#{recipient_three.full_name} (#{recipient_three.email})</li></ul>")
    end
  end

  test "EnrollChat Report email standard content" do
    travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      Sidekiq::Worker.drain_all
      emails = ActionMailer::Base.deliveries[0..2]
      emails.each do |email|
        assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.from
        assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.to
        assert_equal 'EnrollChat Report (Triggered in test)', email.subject
        assert email.body.to_s.include?("<h1>EnrollChat Weekly Report</h1>")
        assert email.body.to_s.include?("<p>EnrollChat provides you with up-to-date enrollment information for the current enrollment term. Log in to gather information on each class, including whether there has been an increase or decrease in enrollment over the previous reporting period. Both the Dean's Office and you have access to this data and should use EnrollChat to regularly communicate about specific courses.<p>")
        assert email.body.to_s.include?("<h2>Sections With Comments</h2>")
      end
    end
  end
  test "EnrollChat Report recipient specific content" do
    travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
      Rake::Task['weekly_reports:send_emails'].invoke
      Sidekiq::Worker.drain_all
      emails = ActionMailer::Base.deliveries[0..2]
      assert emails[0].body.to_s.include?("<td>BIS</td>")
      assert emails[0].body.to_s.include?("<td>ENGL</td>")
      assert emails[0].body.to_s.include?("<td>SINT</td>")
      assert emails[0].body.to_s.include?("<td>CRIM</td>")
      assert emails[0].body.to_s.include?("<p>BIS</p>")
      assert emails[0].body.to_s.include?("<p>ENGL</p>")
      assert emails[0].body.to_s.include?("<p>SINT</p>")
      assert emails[0].body.to_s.include?("<p>CRIM</p>")
      assert emails[1].body.to_s.include?("<td>SINT</td>")
      assert emails[1].body.to_s.include?("<td>CRIM</td>")
      assert emails[1].body.to_s.include?("<td>PHIL</td>")
      assert emails[1].body.to_s.include?("<p>SINT</p>")
      assert emails[1].body.to_s.include?("<p>CRIM</p>")
      assert emails[1].body.to_s.include?("<p>PHIL</p>")
      assert emails[2].body.to_s.include?("<td>BIS</td>")
      assert emails[2].body.to_s.include?("<td>ENGL</td>")
      assert emails[2].body.to_s.include?("<td>SINT</td>")
      assert emails[2].body.to_s.include?("<td>CRIM</td>")
      assert emails[2].body.to_s.include?("<p>BIS</p>")
      assert emails[2].body.to_s.include?("<p>ENGL</p>")
      assert emails[2].body.to_s.include?("<p>SINT</p>")
      assert emails[2].body.to_s.include?("<p>CRIM</p>")
    end
  end
end
