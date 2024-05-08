# typed: true

class PokerSessionParticipantsController < ApplicationController
  def new
    @view_model = PokerSessionParticipants::CreateModel.new(poker_session_id: params[:poker_session_id])
  end

  def create
    @view_model = PokerSessionParticipants::CreateModel.new(
      create_poker_session_participant_params.merge(poker_session_id: params[:poker_session_id])
    )

    if @view_model.valid?
      PokerSessionParticipants::Service.new.create_poker_session_participant!(
        view_model: @view_model,
        session:
      )

      poker_session = PokerSession.find params[:poker_session_id]

      redirect_to poker_session_path(@view_model.poker_session_id), notice: "Успешно!"

      Turbo::StreamsChannel.broadcast_update_to(
        "poker_session_#{@view_model.poker_session_id}",
        partial: "poker_sessions/table",
        locals: {poker_session:},
        target: :table
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  def remove_disabled
    poker_session = PokerSession.find params[:poker_session_id]
    participant = PokerSessionParticipant.find(params[:poker_session_participant_id])
    participant.update!(is_disabled: false)

    Turbo::StreamsChannel.broadcast_update_to(
      "poker_session_#{params[:poker_session_id]}",
      partial: "poker_sessions/table",
      locals: {poker_session:},
      target: :table
    )

    Turbo::StreamsChannel.broadcast_update_to(
      params[:poker_session_participant_id],
      partial: "poker_sessions/test",
      locals: {poker_session:, participant:},
      target: :test
    )

    Turbo::StreamsChannel.broadcast_update_to(
      params[:poker_session_participant_id],
      partial: "poker_sessions/estimates",
      locals: {poker_session:, participant:},
      target: :estimates
    )
  end

  def add_disabled
    poker_session = PokerSession.find params[:poker_session_id]
    participant = PokerSessionParticipant.find(params[:poker_session_participant_id])
    participant.update!(is_disabled: true)

    Turbo::StreamsChannel.broadcast_update_to(
      "poker_session_#{params[:poker_session_id]}",
      partial: "poker_sessions/table",
      locals: {poker_session:},
      target: :table
    )

    Turbo::StreamsChannel.broadcast_update_to(
      params[:poker_session_participant_id],
      partial: "poker_sessions/test",
      locals: {poker_session:, participant:},
      target: :test
    )

    Turbo::StreamsChannel.broadcast_update_to(
      params[:poker_session_participant_id],
      partial: "poker_sessions/estimates",
      locals: {poker_session:, participant:},
      target: :estimates
    )
  end

  private def create_poker_session_participant_params
    params.require(:poker_session_participant).permit(:name)
  end
end
