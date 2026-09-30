class PriorityHighlightController < ApplicationController
  # Same stylesheet for everybody, the lists themselves are protected as usual.
  skip_before_action :check_if_login_required, :check_password_change, :check_twofa_activation

  def show
    # The URL carries a digest (?v=...), so it is safe to cache long.
    expires_in 1.year, public: true
    render plain: RedminePriorityHighlight::Stylesheet.css(RedminePriorityHighlight.color_map),
           content_type: 'text/css'
  end
end
