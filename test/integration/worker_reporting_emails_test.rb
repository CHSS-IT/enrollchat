require 'test_helper'
require 'sidekiq/testing'

class WorkerReportingEmailsTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  include ApplicationHelper

  setup do
    Rake::Task.clear
    Sidekiq::Worker.clear_all
    Enrollchat::Application.load_tasks
    @section = sections(:one)
    @settings = settings(:one)
    @settings.update(email_delivery: 'on')
  end

  teardown do
    Sidekiq::Worker.clear_all
    Rake::Task.clear
  end

  # Daily digest worker
  test "Digest Executed email is generated" do
    Rake::Task['daily_digests:send_emails'].invoke
    Sidekiq::Worker.drain_all
    assert_emails 1
  end

  test "Digest Executed email content" do
    user = users(:two)
    user.departments << 'BIS'
    user.save
    Rake::Task['daily_digests:send_emails'].invoke
    Sidekiq::Worker.drain_all
    email = ActionMailer::Base.deliveries.last
    assert_equal ["no-reply@example.com"], email.from
    assert_equal ["recipient@example.com"], email.to
    assert_equal 'EnrollChat Digest Task Executed (Triggered in test)', email.subject
    assert email.body.to_s.include?("<h1>Departments With Comments</h1>")
    assert email.body.to_s.include?("<p>BIS</p>")
    assert email.body.to_s.include?("<h1>Digests Sent to</h1>")
    assert email.body.to_s.include?("<p>user@email.com</p>")
  end

  test "Daily Digest email is generated" do
    user = users(:two)
    user.departments << 'BIS'
    user.save
    Rake::Task['daily_digests:send_emails'].invoke
    Sidekiq::Worker.drain_all
    assert_emails 2
  end

  test "Digest Digest email content" do
    user = users(:two)
    user.departments << 'BIS'
    user.save
    Rake::Task['daily_digests:send_emails'].invoke
    Sidekiq::Worker.drain_all
    email = ActionMailer::Base.deliveries.first
    assert_equal ["no-reply@example.com"], email.from
    assert_equal ["recipient@example.com"], email.to
    assert_equal 'EnrollChat Comments Digest (Triggered in test)', email.subject
    assert email.body.to_s.include?("<h1>EnrollChat Daily Digest</h1>")
    assert email.body.to_s.include?("<p>EnrollChat allows you to choose to receive daily digests of comments or individual emails each time a comment is posted. You will be notified of comments relevant to your selected programs, or to all programs if you have not selected a department preference.</p>")
    assert email.body.to_s.include?("<h2>EnrollChat Digest Email for BIS")
    assert email.body.to_s.include?(">MyString-001</a>: 1 comment</p>")
  end

  # Weekly report worker
  test "Weekly report emails are generated" do
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        Sidekiq::Worker.drain_all
        assert_emails User.wanting_report.count + 1
      end
    end
  end

  test "'Weekly Report Executed' email content" do
    recipient = users(:one)
    recipient_two = users(:two)
    recipient_three = users(:three)
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        Sidekiq::Worker.drain_all
        email = ActionMailer::Base.deliveries.last
        assert_equal ["no-reply@example.com"], email.from
        assert_equal ["recipient@example.com"], email.to
        assert_equal 'EnrollChat Report Task Executed (Triggered in test)', email.subject
        assert email.body.to_s.include?("<h1>EnrollChat Weekly Report Sent</h1>")
        assert email.body.to_s.include?("<p>Reports sent to:</p>")
        assert email.body.to_s.include?("<ul><li>#{recipient.full_name} (#{recipient.email})</li><li>#{recipient_two.full_name} (#{recipient_two.email})</li><li>#{recipient_three.full_name} (#{recipient_three.email})</li></ul>")
      end
    end
  end

  test "EnrollChat Report email standard content" do
    term = @settings.current_term
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        Sidekiq::Worker.drain_all
        emails = ActionMailer::Base.deliveries[0..2]
        emails.each do |email|
          assert_equal ["no-reply@example.com"], email.from
          assert_equal ["recipient@example.com"], email.to
          assert_equal 'EnrollChat Report (Triggered in test)', email.subject
          assert email.body.to_s.include?("<h1>EnrollChat Weekly Report</h1>")
          assert email.body.to_s.include?("<h3>Information for #{term_in_words(term)}</h3>")
          assert email.body.to_s.include?("<p>EnrollChat provides you with up-to-date enrollment information for the current enrollment term. Log in to gather information on each class, including whether there has been an increase or decrease in enrollment over the previous reporting period. Both the Dean's Office and you have access to this data and should use EnrollChat to regularly communicate about specific courses.<p>")
          assert email.body.to_s.include?("<h2>Sections With Comments</h2>")
        end
      end
    end
  end

  test "EnrollChat Report recipient specific content" do
    Time.use_zone("Eastern Time (US & Canada)") do
      travel_to Time.zone.local(2018, 11, 15, 1, 4, 44) do
        Rake::Task['weekly_reports:send_emails'].invoke
        Sidekiq::Worker.drain_all
        emails = ActionMailer::Base.deliveries[0..2]
        assert emails[0].body.to_s.include?("<td>BIS</td>")
        assert emails[0].body.to_s.include?("<td>ENGL</td>")
        assert emails[0].body.to_s.include?("<td>SINT</td>")
        assert emails[0].body.to_s.include?("<td>CRIM</td>")
        assert emails[1].body.to_s.include?("<td>SINT</td>")
        assert emails[1].body.to_s.include?("<td>CRIM</td>")
        assert emails[1].body.to_s.include?("<td>PHIL</td>")
        assert_not emails[2].body.to_s.include?("<td>BIS</td>")
        assert_not emails[2].body.to_s.include?("<td>ENGL</td>")
        assert_not emails[2].body.to_s.include?("<td>SINT</td>")
        assert_not emails[2].body.to_s.include?("<td>CRIM</td>")
      end
    end
  end
end
