class ApplicationController < ActionController::Base
  def verify_poker_session_context(poker_session_id)
    poker_sessions = session[:poker_sessions]

    if poker_sessions.present?
      current_poker_session_context = poker_sessions.find { |session| session["poker_session_id"] == poker_session_id }

      return current_poker_session_context if current_poker_session_context.present?
    end

    false
  end

  def redirect_to(options = {}, response_options = {})
    turbo_frame = response_options.delete(:turbo_frame)
    turbo_action = response_options.delete(:turbo_action)
    return super unless request.format.turbo_stream? && turbo_frame.present?

    allow_other_host = response_options.delete(:allow_other_host) { _allow_other_host }
    location = _enforce_open_redirect_protection(_compute_redirect_to_location(request, options), allow_other_host: allow_other_host)

    self.class._flash_types.each do |flash_type|
      if (type = response_options.delete(flash_type))
        flash[flash_type] = type
      end
    end

    if (other_flashes = response_options.delete(:flash))
      flash.update(other_flashes)
    end

    render turbo_stream: turbo_visit(location, frame: turbo_frame, action: turbo_action)
  end

  def turbo_visit(url, frame: nil, action: nil)
    options = {frame: frame, action: action}.compact
    turbo_stream.append_all("head") do
      helpers.javascript_tag(<<~SCRIPT.strip, nonce: true, data: {turbo_cache: false})
        window.Turbo.visit("#{helpers.escape_javascript(url)}", #{options.to_json})
        document.currentScript.remove()
      SCRIPT
    end
  end
end
