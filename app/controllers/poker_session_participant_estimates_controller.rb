# typed: true

class PokerSessionParticipantEstimatesController < ApplicationController
  def create
    if verify_poker_session_context(create_params[:poker_session_id])
      poker_session = PokerSession.find(create_params[:poker_session_id])
      poker_session_participant =
        PokerSessionParticipant
          .includes(:poker_session_participant_estimate)
          .find(create_params[:poker_session_participant_id])

      if estimate = poker_session_participant.poker_session_participant_estimate
        estimate.update!(value: create_params[:value])
      else
        PokerSessionParticipantEstimate.create!(create_params)
      end

      Turbo::StreamsChannel.broadcast_update_to(
        "poker_session_#{create_params[:poker_session_id]}",
        partial: "poker_sessions/table",
        locals: {poker_session:},
        target: :table
      )

      Turbo::StreamsChannel.broadcast_update_to(
        poker_session_participant.id,
        partial: "poker_sessions/estimates",
        locals: {poker_session:, participant: poker_session_participant.reload},
        target: :estimates
      )
    else
      redirect_to new_poker_session_poker_session_participant_path(create_params[:poker_session_id])
    end
  end

  private def create_params
    params.permit(:value, :poker_session_id, :poker_session_participant_id)
  end
end
