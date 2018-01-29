require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  test 'comment activity feed displays proper unread notifications for a user' do
    @comment_two = comments(:two)
    @comment_three = comments(:three)
    login_as users(:two)
    visit sections_url
    click_button('Activity')
    assert_text('Criminal Justice-001: Anthony DiNozzo less than a minute ago')
    assert_text('Experiential Learning-001: Jethro Gibbs less than a minute ago')
    refute_text('MyString-001: Jethro Gibbs less than a minute ago')
    take_screenshot
  end

  test 'comment activity feed displays the five most recent notifications for a user when there are no unread notifications' do
    login_as users(:one)
    @comment_one = comments(:one)
    @comment_two = comments(:two)
    @comment_three = comments(:three)
    @comment_four = comments(:four)
    @comment_five = comments(:yesterday)
    @comment_six = comments(:old)
    visit sections_url
    click_button('Activity')
    assert_text('MyString-001: Jethro Gibbs less than a minute ago')
    assert_text('Criminal Justice-001: Anthony DiNozzo less than a minute ago')
    assert_text('Experiential Learning-001: Jethro Gibbs less than a minute ago')
    assert_text('MyString-001: Jethro Gibbs less than a minute ago')
    assert_text('MyString-001: Jethro Gibbs 1 day ago')
    refute_text('MyString-001: Jethro Gibbs 2 days ago')
    take_screenshot
  end
end
