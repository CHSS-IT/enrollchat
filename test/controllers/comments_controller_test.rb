require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section = sections(:one)
    @comment = comments(:one)
    login_as users(:one)
  end

  test "should get index" do
    get section_comments_url(@section)
    assert_response :success
  end

  test "should get new" do
    get new_section_comment_url(@section)
    assert_response :success
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post section_comments_url(@section), params: { comment: { body: @comment.body, section_id: @comment.section_id, user_id: @comment.user_id } }
    end
    assert_redirected_to sections_url
  end

  test "should show comment" do
    get section_comment_url(@section, @comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_section_comment_url(@section, @comment)
    assert_response :success
  end

  test "should update comment" do
    patch section_comment_url(@section, @comment), params: { comment: { body: @comment.body, section_id: @comment.section_id, user_id: @comment.user_id } }
    assert_redirected_to section_comment_url(@section, @comment)
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete section_comment_url(@section, @comment)
    end

    assert_redirected_to section_comments_url
  end
end
