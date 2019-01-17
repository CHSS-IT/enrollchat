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
end
