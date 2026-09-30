# Redmine Priority Highlight
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

require_relative 'lib/redmine_priority_highlight'

Redmine::Plugin.register :redmine_priority_highlight do
  name 'Redmine Priority Highlight'
  description 'Highlights issues in lists by priority; can be enabled per saved query'
  version RedminePriorityHighlight::VERSION
  requires_redmine version_or_higher: '6.0'

  # Holds the id of the color custom field (written by the migration).
  settings default: {'color_field_id' => nil}
end

# Redmine runs this file inside its own to_prepare callback (see
# Redmine::PluginLoader.load), so it is executed again on every code reload.
# A nested Rails.configuration.to_prepare would be registered too late and
# never run, so the patch is applied directly.
unless IssueQuery.include?(RedminePriorityHighlight::IssueQueryPatch)
  IssueQuery.prepend RedminePriorityHighlight::IssueQueryPatch
end
