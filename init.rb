require_relative 'lib/redmine_priority_highlight'

Redmine::Plugin.register :redmine_priority_highlight do
  name 'Redmine Priority Highlight'
  description 'Highlights issues in lists by priority; can be enabled per saved query'
  version RedminePriorityHighlight::VERSION
  requires_redmine version_or_higher: '6.0'

  # Holds the id of the color custom field (written by the migration).
  settings default: {'color_field_id' => nil}
end

Rails.configuration.to_prepare do
  unless IssueQuery.include?(RedminePriorityHighlight::IssueQueryPatch)
    IssueQuery.prepend RedminePriorityHighlight::IssueQueryPatch
  end
end
