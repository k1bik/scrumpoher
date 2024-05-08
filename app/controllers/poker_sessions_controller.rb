# typed: true

class PokerSessionsController < ApplicationController
  def show
    poker_session_id = params[:id]
    @poker_session =
      PokerSession.includes(poker_session_participants: :poker_session_participant_estimate).find poker_session_id

    set_poker_session_context(poker_session_id)
  end

  def new
    @view_model = PokerSessions::CreateModel.new
  end

  def edit
    poker_session_id = params[:id]
    return if !set_poker_session_context(poker_session_id)

    @poker_session = PokerSession.find poker_session_id
    @view_model = PokerSessions::CreateModel.new(estimates: @poker_session.estimates)
  end

  def update
    poker_session_id = params[:id]
    return if !set_poker_session_context(poker_session_id)

    @view_model = PokerSessions::CreateModel.new(create_poker_session_params)
    @poker_session = PokerSession.find poker_session_id

    if @view_model.valid?
      @poker_session.update!(estimates: @view_model.estimates)

      @poker_session.poker_session_participants.each do |participant|
        Turbo::StreamsChannel.broadcast_update_to(
          participant.id,
          partial: "poker_sessions/estimates",
          locals: {poker_session: @poker_session, participant:},
          target: :estimates
        )
      end

      redirect_to poker_session_path(@poker_session.reload), turbo_frame: "_top"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @view_model = PokerSessions::CreateModel.new(create_poker_session_params)

    if @view_model.valid?
      poker_sesion = PokerSession.create!(estimates: @view_model.estimates)

      redirect_to poker_session_path(poker_sesion), turbo_frame: "_top"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def toggle_estimates_visibility
    return if !set_poker_session_context(params[:poker_session_id])

    poker_session = PokerSession.find params[:poker_session_id]

    poker_session.toggle!(:show_estimates)

    Turbo::StreamsChannel.broadcast_update_to(
      "poker_session_#{params[:poker_session_id]}",
      partial: "poker_sessions/table",
      locals: {poker_session:},
      target: :table
    )
  end

  def delete_estimates
    return if !set_poker_session_context(params[:poker_session_id])

    poker_session = PokerSession.find params[:poker_session_id]

    PokerSessionParticipantEstimate.where(poker_session_id: params[:poker_session_id]).destroy_all
    poker_session.update!(show_estimates: false)

    Turbo::StreamsChannel.broadcast_update_to(
      "poker_session_#{params[:poker_session_id]}",
      partial: "poker_sessions/table",
      locals: {poker_session:},
      target: :table
    )

    poker_session.poker_session_participants.each do |participant|
      Turbo::StreamsChannel.broadcast_update_to(
        participant.id,
        partial: "poker_sessions/estimates",
        locals: {poker_session:, participant:},
        target: :estimates
      )
    end
  end

  private def create_poker_session_params
    params.require(:poker_session).permit(:estimates)
  end
end
