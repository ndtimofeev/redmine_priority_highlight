class CreatePriorityHighlightField < ActiveRecord::Migration[8.1]
  FIELD_NAME = 'Highlight color'.freeze

  def up
    field = IssuePriorityCustomField.find_by(name: FIELD_NAME) ||
            IssuePriorityCustomField.create!(
              name: FIELD_NAME,
              field_format: 'string',
              regexp: '^#[0-9a-fA-F]{6}$',
              description: 'Hex color (#rrggbb) used to highlight issues by priority',
              is_required: false,
              visible: true,
              editable: true
            )
    Setting.plugin_redmine_priority_highlight = {'color_field_id' => field.id}

    fill_default_colors(field)
  end

  def down
    id = Setting.plugin_redmine_priority_highlight['color_field_id']
    IssuePriorityCustomField.where(id: id).destroy_all if id
    Setting.plugin_redmine_priority_highlight = {}
  end

  private

  # Only fills priorities that have no color yet, so values entered by hand
  # (or by an earlier run) are never overwritten.
  def fill_default_colors(field)
    priorities = IssuePriority.active.sorted.to_a
    return if priorities.empty?

    normal = IssuePriority.default_or_middle
    normal_index = priorities.index(normal) || (priorities.size - 1) / 2
    colors = RedminePriorityHighlight::DefaultScheme.colors(priorities.map(&:id), normal_index)

    priorities.each do |priority|
      next if priority.custom_field_value(field).present?
      next unless (color = colors[priority.id])

      priority.custom_field_values = {field.id.to_s => color}
      priority.save!
    end
  end
end
