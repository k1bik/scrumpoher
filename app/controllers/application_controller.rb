class ApplicationController < ActionController::Base
  def set_poker_session_context(poker_session_id)
    poker_session_context = session[:poker_sessions]&.find { _1["poker_session_id"] == poker_session_id }

    if poker_session_context && PokerSessionParticipant.exists?(poker_session_context["participant_id"])
      @poker_session_context = poker_session_context
      @participant = PokerSessionParticipant.find poker_session_context["participant_id"]
      true
    else
      redirect_to new_poker_session_poker_session_participant_path(poker_session_id)
      false
    end
  end
end
