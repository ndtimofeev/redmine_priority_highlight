module RedminePriorityHighlight
  VERSION = '0.1.0'.freeze

  # { priority_id => '#rrggbb' }; priorities without a valid color are omitted,
  # so Redmine's own styling stays in effect for them.
  def self.color_map
    field_id = Setting.plugin_redmine_priority_highlight['color_field_id']
    field = field_id && IssuePriorityCustomField.find_by(id: field_id)
    return {} unless field

    CustomValue.where(custom_field_id: field.id, customized_type: 'Enumeration').
      pluck(:customized_id, :value).
      select {|_id, value| value =~ Stylesheet::COLOR_RE}.
      to_h
  end
end

require_relative 'redmine_priority_highlight/stylesheet'
require_relative 'redmine_priority_highlight/default_scheme'
require_relative 'redmine_priority_highlight/issue_query_patch'
require_relative 'redmine_priority_highlight/hooks'
