require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setting = settings(:one)
    @section = sections(:one)
    @comment = comments(:one)
    @user = users(:two)
  end

  teardown do
    logout
  end

  test 'should GET index' do
    login_as(@user)
    get section_comments_url(@section)
    assert_response :success
  end

  test 'should not GET index for an unregistered user' do
    unregistered_login
    get section_comments_url(@section)
    assert_redirected_to unregistered_path
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end

  test 'should get new' do
    login_as(@user)
    get new_section_comment_url(@section)
    assert_response :success
  end

  test 'should not GET new for an unregistered user' do
    unregistered_login
    get new_section_comment_url(@section)
    assert_redirected_to unregistered_path
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end

  test 'should create comment' do
    login_as(@user)
    assert_difference('Comment.count', 1) do
      post section_comments_url(@section), params: { comment: { body: @comment.body, section_id: @comment.section_id, user_id: @comment.user_id } }
    end
    assert_redirected_to sections_url
  end

  test 'should not create comment for an archived user' do
    @user.update(status: 'archived')
    login_as(@user)
    assert_no_difference('Comment.count') do
      post section_comments_url(@section), params: { comment: { body: @comment.body, section_id: @comment.section_id, user_id: @user.id } }
    end
    assert_redirected_to sections_url
    assert_equal 'Unable to post comment. Please contact the administrators to activate your account.', flash[:notice]
  end

  test 'should not create comment for an unregistered user' do
    unregistered_login
    assert_no_difference('Comment.count') do
      post section_comments_url(@section), params: { comment: { body: @comment.body, section_id: @comment.section_id } }
      assert_redirected_to unregistered_path
      assert_equal 'You are not registered to use this system.', flash[:notice]
    end
  end

  test 'should GET edit for an admin' do
    login_as(users(:one))
    get edit_section_comment_url(@section, @comment)
    assert_response :success
  end

  test 'should not GET edit for an user' do
    login_as(@user)
    get edit_section_comment_url(@section, @comment)
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page.', flash[:notice]
  end

  test 'should not GET edit for an unregistered user' do
    unregistered_login
    get edit_section_comment_url(@section, @comment)
    assert_redirected_to unregistered_path
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end

  test 'should update comment for an admin' do
    login_as(users(:one))
    patch section_comment_url(@section, @comment), params: { comment: { body: "New Comment", section_id: @comment.section_id, user_id: @comment.user_id } }
    assert_redirected_to section_comment_url(@section, @comment)
    assert_equal @comment.reload.body, 'New Comment'
  end

  test "should not update comment for a user" do
    login_as(@user)
    patch section_comment_url(@section, @comment), params: { comment: { body: "New Comment", section_id: @comment.section_id, user_id: @comment.user_id } }
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page.', flash[:notice]
    assert_not_equal @comment.reload.body, 'New Comment'
  end

  test 'should not update a comment for an unregistered user' do
    unregistered_login
    patch section_comment_url(@section, @comment), params: { comment: { body: "New Comment", section_id: @comment.section_id, user_id: @comment.user_id } }
    assert_redirected_to unregistered_url
    assert_equal 'You are not registered to use this system.', flash[:notice]
    assert_not_equal @comment.reload.body, 'New Comment'
  end

  test 'should destroy comment for an admin' do
    login_as(users(:one))
    assert_difference('Comment.count', -1) do
      delete section_comment_url(@section, @comment)
    end
    assert_redirected_to section_comments_url
  end

  test 'should not destroy comment for a user' do
    login_as(@user)
    assert_no_difference('Comment.count') do
      delete section_comment_url(@section, @comment)
    end
    assert_redirected_to sections_url
    assert_equal 'You do not have access to this page.', flash[:notice]
  end

  test 'should not destroy comment for an unregistered user' do
    unregistered_login
    assert_no_difference('Comment.count') do
      delete section_comment_url(@section, @comment)
    end
    assert_redirected_to unregistered_url
    assert_equal 'You are not registered to use this system.', flash[:notice]
  end
end
