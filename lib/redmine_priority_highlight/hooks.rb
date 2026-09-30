module RedminePriorityHighlight
  class Hooks < Redmine::Hook::ViewListener
    # Runs on every page, so a failure here must never break Redmine:
    # it only costs the highlighting.
    def view_layouts_base_html_head(context)
      map = RedminePriorityHighlight.color_map
      href = priority_highlight_path(v: Stylesheet.digest(map, VERSION), format: 'css')

      tag.link(rel: 'stylesheet', href: href) + query_form_script(context[:controller])
    rescue StandardError => e
      Rails.logger.error "redmine_priority_highlight: #{e.class}: #{e.message}"
      ''.html_safe
    end

    private

    # There is no hook in queries/_form.html.erb, so the select is injected
    # into fieldset#options on the query new/edit pages.
    def query_form_script(controller)
      return ''.html_safe unless controller.controller_name == 'queries' &&
                                 %w(new edit create update).include?(controller.action_name)

      query = controller.instance_variable_get(:@query)
      return ''.html_safe unless query.is_a?(IssueQuery) && query.respond_to?(:priority_highlight)
      return ''.html_safe if controller.params[:gantt] || controller.params[:calendar]

      choices = [[nil, :label_priority_highlight_none]] +
                IssueQueryPatch::MODES.map {|mode| [mode, :"label_priority_highlight_#{mode}"]}
      data = {
        label: ::I18n.t(:field_priority_highlight),
        selected: query.priority_highlight.to_s,
        choices: choices.map {|value, key| {value: value.to_s, label: ::I18n.t(key)}}
      }

      javascript_tag(<<~JS)
        $(function() {
          var data = #{ERB::Util.json_escape(data.to_json)};
          var $options = $('fieldset#options');
          if (!$options.length) return;
          var $select = $('<select>', {id: 'query_priority_highlight', name: 'query[priority_highlight]'});
          $.each(data.choices, function(_, choice) {
            $('<option>', {value: choice.value}).text(choice.label).appendTo($select);
          });
          $select.val(data.selected);
          $options.append(
            $('<p>').append($('<label>', {'for': 'query_priority_highlight'}).text(data.label), $select)
          );
        });
      JS
    end
  end
end
