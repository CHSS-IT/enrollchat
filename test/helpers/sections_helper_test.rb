require 'test_helper'

class SectionHelperTest < ActionView::TestCase
  include SectionsHelper

  setup do
    @section = sections(:one)
  end

  test "combines section day and time into a string for display" do
    @section.update(days: "TR", start_time: "10:30", end_time: "13:20")
    assert_equal day_and_time(@section), "#{@section.days} #{@section.formatted_time(@section.start_time)}-#{@section.formatted_time(@section.end_time)}"
  end
end
