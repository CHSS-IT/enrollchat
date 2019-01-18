require 'test_helper'

class CommentsMailerTest < ActionMailer::TestCase

  test "import reporting email generated" do
    assert_emails 1 do
      Section.import(file_fixture('test_crse.csv'))
    end
  end

  test "import reporting email content" do
    Section.import(file_fixture('test_crse.csv'))
    email = ActionMailer::Base.deliveries.last
    assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.from
    assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.to
    assert_equal 'Import Processed (Triggered in test)', email.subject
    assert_equal read_fixture('import_processed.html').join, email.body.to_s
  end

  test "schedule old term purge email is generated" do
    Rake::Task.clear
    Enrollchat::Application.load_tasks
    travel_to Time.zone.local(2019, 01, 10, 10, 04, 44) do
      assert_emails 1 do
        Rake::Task['scheduler:schedule_old_term_purge'].invoke
      end
    end
    Rake::Task.clear
  end

  test "schedule old term purge email content" do
    Rake::Task.clear
    Enrollchat::Application.load_tasks
    travel_to Time.zone.local(2019, 01, 10, 10, 04, 44) do
      Rake::Task['scheduler:schedule_old_term_purge'].invoke
    end
    email = ActionMailer::Base.deliveries.last
    assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.from
    assert_equal [ENV['ENROLLCHAT_ADMIN_EMAIL']], email.to
    assert_equal 'Terms Marked for Deletion (Triggered in test)', email.subject
    assert_equal read_fixture('deletion_scheduled.html').join, email.body.to_s
  end
end
