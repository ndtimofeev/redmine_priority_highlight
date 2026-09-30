module RedminePriorityHighlight
  # Default colors depend on the distance from the "normal" priority, not on
  # names or ids, so they work for any number of priorities. Colors come from
  # Open Color, the palette Redmine's own theme is built on.
  #
  #   normal  -> no color (Redmine's own look)
  #   below   -> grays, the lower the paler
  #   above   -> orange -> red, the highest one is always red
  module DefaultScheme
    BELOW = %w(#adb5bd #ced4da).freeze          # nearest to normal .. lowest
    ABOVE = %w(#ffa94d #ff922b #fa5252).freeze  # weakest .. strongest

    # +ids+ are priority ids ordered by position, +normal_index+ is the index
    # of the normal (default) priority in that list.
    # Returns { priority_id => '#rrggbb' }.
    def self.colors(ids, normal_index)
      colors = {}

      below = ids[0, normal_index].reverse
      below.each_with_index do |id, i|
        colors[id] = BELOW[[i, BELOW.size - 1].min]
      end

      above = ids[(normal_index + 1)..] || []
      above.each_with_index do |id, i|
        colors[id] = ABOVE[[ABOVE.size - above.size + i, 0].max]
      end

      colors
    end
  end
end
