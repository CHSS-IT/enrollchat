require "application_system_test_case"

class SectionsTest < ApplicationSystemTestCase
  setup do
    login_as users(:one)
  end

  test 'visiting the index' do
    visit sections_url
    assert_selector 'h1', text: 'Sections'
    assert page.has_css?('table tbody tr', count: 4)
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

  test 'filtering by level' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('Graduate - First', from: 'section_level')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'CRIM'
    assert_selector 'table tbody tr td', text: 'Criminal Justice'
    assert_selector 'table tbody tr td', text: 'Graduate - First'
    select('Graduate - Advanced', from: 'section_level')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'SINT'
    assert_selector 'table tbody tr td', text: 'Experiential Learning'
    assert_selector 'table tbody tr td', text: 'Graduate - Advanced'
    select('Undergraduate - Lower Division', from: 'section_level')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    assert_selector 'table tbody tr td', text: 'BIS'
    assert_selector 'table tbody tr td', text: 'MyString'
    assert_selector 'table tbody tr td', text: 'Undergraduate - Lower Division'
    select('Undergraduate - Upper Division', from: 'section_level')
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
    assert_selector 'table tbody tr td', text: '13'
  end

  test 'clearing filters' do
    visit sections_url
    assert_selector 'table tbody tr', count: 4
    select('CRIM', from: 'section_department')
    click_link('filter-submit')
    assert_selector 'table tbody tr', count: 1
    click_link('Clear Filters')
    assert_selector 'table tbody tr', count: 4
  end
end
