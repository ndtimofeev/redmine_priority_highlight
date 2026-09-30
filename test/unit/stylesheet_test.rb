require 'minitest/autorun'
require_relative '../../lib/redmine_priority_highlight/stylesheet'

# Runs without Redmine: ruby test/unit/stylesheet_test.rb
class StylesheetTest < Minitest::Test
  Sheet = RedminePriorityHighlight::Stylesheet

  def test_defines_a_variable_per_priority
    css = Sheet.css(3 => '#ffa94d', 5 => '#fa5252')
    assert_includes css, 'tr.issue.priority-3 { --priority-highlight: #ffa94d; }'
    assert_includes css, 'tr.issue.priority-5 { --priority-highlight: #fa5252; }'
  end

  def test_rejects_anything_but_a_hex_color
    css = Sheet.css(1 => 'red', 2 => '#fff', 3 => '#ffa94d; } body { display: none', 4 => "#ffa94d\n")
    refute_match(/--priority-highlight:/, css)
  end

  def test_ids_are_forced_to_integers
    css = Sheet.css('7}body{x' => '#ffa94d')
    assert_includes css, 'tr.issue.priority-7 {'
    refute_includes css, 'body{x'
  end

  def test_without_colors_only_static_rules_remain
    assert_equal Sheet::MODES_CSS, Sheet.css({})
  end

  def test_digest_changes_with_colors_and_version_not_with_order
    a = Sheet.digest({1 => '#adb5bd', 2 => '#fa5252'}, '1.0.0')
    assert_equal a, Sheet.digest({2 => '#fa5252', 1 => '#adb5bd'}, '1.0.0')
    refute_equal a, Sheet.digest({1 => '#adb5bd', 2 => '#ff922b'}, '1.0.0')
    refute_equal a, Sheet.digest({1 => '#adb5bd', 2 => '#fa5252'}, '9.9.9')
  end
end
