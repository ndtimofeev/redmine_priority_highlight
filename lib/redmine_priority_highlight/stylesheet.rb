require 'digest'

module RedminePriorityHighlight
  # Pure functions, no Redmine needed: the mode rules are static, only the
  # per-priority color variable comes from the database.
  module Stylesheet
    COLOR_RE = /\A#\h{6}\z/

    # Rows that are closed or selected in the context menu are left alone:
    # Redmine already paints them and the selection is !important.
    ROW = 'tr.issue:not(.closed):not(.context-menu-selection)'.freeze

    MODES_CSS = <<~CSS.freeze
      table.list.priority-highlight #{ROW} td:first-child {
        box-shadow: inset 4px 0 0 var(--priority-highlight, transparent);
      }
      table.list.priority-highlight--cell #{ROW} td.priority {
        background-color: color-mix(in srgb, var(--priority-highlight, transparent) 30%, transparent);
      }
      table.list.priority-highlight--row #{ROW} td {
        background-color: color-mix(in srgb, var(--priority-highlight, transparent) 16%, transparent);
      }
    CSS

    # Changes with the colors and with the plugin version (the mode rules),
    # so it can version the stylesheet URL.
    def self.digest(map, version = VERSION)
      Digest::SHA1.hexdigest([version, map.sort].to_s)[0, 12]
    end

    def self.css(map)
      vars = map.filter_map do |id, color|
        next unless color =~ COLOR_RE

        "tr.issue.priority-#{id.to_i} { --priority-highlight: #{color}; }\n"
      end
      vars.join + MODES_CSS
    end
  end
end
