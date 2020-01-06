require "application_system_test_case"

class SectionsTest < ApplicationSystemTestCase
  setup do
    login_as(users(:one))
  end

  teardown do
    logout
  end

  test 'visiting the index' do
    visit sections_url
    assert_selector 'h1', text: 'Sections'
    assert page.has_css?('table tbody tr', count: 4)
  end

  test 'displays the term passed in as a parameter if one exists' do
    @section = sections(:one)
    @section.update(term: 202010)
    visit sections_url(term: "202010")
    assert_selector 'h1', text: 'Spring 2020 Sections'
  end

  test 'displays current term when a current term settings exists' do
    visit sections_url
    assert_selector 'h1', text: 'Spring 2018 Sections'
  end

  test 'displays the maximum term available when no current term setting or cookie exists.' do
    @settings = settings(:one)
    @settings.update(current_term: nil)
    @section = sections(:one)
    @section.update(term: 202010)
    Capybara.current_session.driver.browser.manage.delete_cookie 'term'
    visit sections_url
    assert_selector 'h1', text: 'Spring 2020 Sections'
    @section.update(term: 201810)
    Capybara.current_session.driver.browser.manage.delete_cookie 'term'
  end

  test 'filtering by department' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('BIS', from: 'section_department')
    click_link('filter-submit')
    assert_selector 'a', text: 'Clear Filters'
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'BIS'
    assert_selector 'table tbody tr td', text: 'MyString-001'
    assert_selector 'table tbody tr td', text: 'Undergraduate - Lower Division'
  end

  test 'filtering by status' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('CL', from: 'section_status')
    click_link('filter-submit')
    assert_selector 'a', text: 'Clear Filters'
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'ENGL'
    assert_selector 'table tbody tr td', text: 'CL'
    assert_selector 'table tbody tr td', text: 'Undergraduate - Upper Division'
  end

  test 'filtering by graduate level' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('Graduate - First', from: 'section_level')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'CRIM'
    assert_selector 'table tbody tr td', text: 'Criminal Justice'
    assert_selector 'table tbody tr td', text: 'Graduate - First'
    select('Graduate - Advanced', from: 'section_level')
    sleep 2
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'SINT'
    assert_selector 'table tbody tr td', text: 'Experiential Learning'
    assert_selector 'table tbody tr td', text: 'Graduate - Advanced'
  end

  test 'filtering by undergraduate level' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('Undergraduate - Lower Division', from: 'section_level')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'BIS'
    assert_selector 'table tbody tr td', text: 'MyString'
    assert_selector 'table tbody tr td', text: 'Undergraduate - Lower Division'
    select('Undergraduate - Upper Division', from: 'section_level')
    sleep 2
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'ENGL'
    assert_selector 'table tbody tr td', text: 'MyString'
    assert_selector 'table tbody tr td', text: 'Undergraduate - Upper Division'
  end

  test 'filtering by flagged as' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('under-enrolled', from: 'section_flagged')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 2
    assert_selector 'table tbody tr td', text: 'SINT'
    assert_selector 'table tbody tr td', text: 'ENGL'
    select('long-waitlist', from: 'section_flagged')
    sleep 2
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'CRIM'
  end

  test 'applying multiple filters' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('under-enrolled', from: 'section_flagged')
    select('ENGL', from: 'section_department')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'ENGL'
    assert_selector 'table tbody tr td', text: '11'
  end

  test 'clearing filters' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('CRIM', from: 'section_department')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    sleep 2
    click_link('Clear Filters')
    assert_selector 'table tbody tr', count: 4
  end
end
