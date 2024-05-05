# typed: true

class PokerSessionParticipantEstimatesController < ApplicationController
  def create
    return if !set_poker_session_context(create_poker_session_participant_estimate_params[:poker_session_id])

    poker_session = PokerSession.find create_poker_session_participant_estimate_params[:poker_session_id]
    poker_session_participant =
      PokerSessionParticipant
        .includes(:poker_session_participant_estimate)
        .find create_poker_session_participant_estimate_params[:poker_session_participant_id]

    if estimate = poker_session_participant.poker_session_participant_estimate
      estimate.update!(value: create_poker_session_participant_estimate_params[:value])
    else
      PokerSessionParticipantEstimate.create! create_poker_session_participant_estimate_params
    end

    Turbo::StreamsChannel.broadcast_update_to(
      "poker_session_#{create_poker_session_participant_estimate_params[:poker_session_id]}",
      partial: "poker_sessions/table",
      locals: {poker_session:},
      target: :table
    )
  end

  private def create_poker_session_participant_estimate_params
    params.permit(:value, :poker_session_id, :poker_session_participant_id)
  end
end
