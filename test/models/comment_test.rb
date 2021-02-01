require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @setting = settings(:one)
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

  test 'finds all recent unread comments for a user' do
    @user = users(:three)
    @comment_two = comments(:two)
    @comment_three = comments(:three)
    @comment_four = comments(:four)
    assert_equal Comment.recent_unread(@user), [@comment, @comment_two, @comment_three, @comment_four]
  end

  test "should not call comments before user's last activity date as unread" do
    @user = users(:three)
    @old_comment = comments(:old)
    assert_not_includes Comment.recent_unread(@user).to_a, @old_comment
  end

  test "finds comments for a user's selected departments" do
    @user = users(:two)
    @comment_two = comments(:two)
    @comment_three = comments(:three)
    @old_comment = comments(:old)
    assert_equal Comment.recent_by_interest(@user), [@comment_two, @comment_three, @old_comment]
  end

  test "finds unread comments for a user's selected departments" do
    @user = users(:two)
    @comment_two = comments(:two)
    @comment_three = comments(:three)
    assert_equal Comment.recent_unread_by_interest(@user), [@comment_two, @comment_three]
  end
end
