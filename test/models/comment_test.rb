require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:one)
  end

  test 'calling yesterday should find comments from yesterday' do
    @yesterday = comments(:yesterday)
    assert_equal Comment.yesterday.to_a, [@yesterday]
  end

  test 'calling yesterday should not find comments from today' do
    assert_not_equal Comment.yesterday.to_a, [@comment]
  end

  test 'calling yesterday should not call comments before yesterday' do
    @old_comment = comments(:old)
    assert_not_equal Comment.yesterday.to_a, [@old_comment]
  end

  test 'finds comments on a department' do
    assert_includes Comment.for_department('BIS').to_a, @comment
  end

  test "finds comments for a user's selected departments and their departments of interest" do
    @user = users(:two)
    @comment_two = comments(:two)
    @comment_three = comments(:three)
    assert_equal Comment.recent_by_interest(@user), [@comment_two, @comment_three]
  end

  test 'finds unread comments based on a the last_activity_check of the user' do
    @user = users(:two)
    @comment_two = comments(:two)
    @comment_three = comments(:three)
    assert_equal Comment.recent_unread_by_interest(@user), [@comment_two, @comment_three]
  end
end
