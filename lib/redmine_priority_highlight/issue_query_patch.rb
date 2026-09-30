module RedminePriorityHighlight
  # Stores the mode in Query#options, the same way IssueQuery does for
  # draw_relations / draw_progress_line.
  module IssueQueryPatch
    MODES = %w(cell row stripe).freeze

    # nil (off) or one of MODES
    def priority_highlight
      mode = options[:priority_highlight]
      mode if MODES.include?(mode)
    end

    def priority_highlight=(arg)
      options[:priority_highlight] = (MODES.include?(arg) ? arg : nil)
    end

    def build_from_params(params, defaults = {})
      super
      # A blank value from the form means "off", so only nil falls through.
      self.priority_highlight =
        params[:priority_highlight] ||
          (params[:query] && params[:query][:priority_highlight]) ||
          options[:priority_highlight]
      self
    end

    # Rendered on <table class="list issues ..."> in issues/_list.html.erb.
    def css_classes
      extra = ("priority-highlight priority-highlight--#{priority_highlight}" if priority_highlight)
      [super, extra].compact.join(' ')
    end
  end
end
