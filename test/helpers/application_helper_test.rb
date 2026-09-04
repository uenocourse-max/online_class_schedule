require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "schedule status describes past, current, and future dates" do
    assert_equal "Selesai", schedule_status(Schedule.new(schedule_date: Date.current - 1.day))
    assert_equal "Hari ini", schedule_status(Schedule.new(schedule_date: Date.current))
    assert_equal "Akan datang", schedule_status(Schedule.new(schedule_date: Date.current + 1.day))
  end

  test "schedule status class is suitable for CSS" do
    assert_equal "hari-ini", schedule_status_class(Schedule.new(schedule_date: Date.current))
  end
end
