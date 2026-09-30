require 'minitest/autorun'
require_relative '../../lib/redmine_priority_highlight/default_scheme'

# Runs without Redmine: ruby test/unit/default_scheme_test.rb
class DefaultSchemeTest < Minitest::Test
  Scheme = RedminePriorityHighlight::DefaultScheme

  def test_stock_redmine_priorities
    # Low, Normal, High, Urgent, Immediate; normal is the second one
    colors = Scheme.colors([1, 2, 3, 4, 5], 1)
    assert_equal({1 => '#adb5bd', 3 => '#ffa94d', 4 => '#ff922b', 5 => '#fa5252'}, colors)
  end

  def test_normal_priority_has_no_color
    refute Scheme.colors([1, 2, 3], 1).key?(2)
  end

  def test_highest_is_always_red
    [2, 3, 5, 9].each do |size|
      ids = (1..size).to_a
      assert_equal '#fa5252', Scheme.colors(ids, 0)[ids.last] if size > 1
    end
  end

  def test_many_levels_below_fade_to_the_palest
    colors = Scheme.colors([1, 2, 3, 4, 5], 4)
    assert_equal '#adb5bd', colors[4]
    assert_equal '#ced4da', colors[1]
  end

  def test_single_priority
    assert_equal({}, Scheme.colors([1], 0))
  end
end
