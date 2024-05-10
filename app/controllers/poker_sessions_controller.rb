# typed: true

class PokerSessionsController < ApplicationController
  def show
    if context = verify_poker_session_context(params[:id])
      @poker_session =
        PokerSession.includes(poker_session_participants: :poker_session_participant_estimate).find(params[:id])
      @participant = PokerSessionParticipant.find(context["participant_id"])
    else
      redirect_to new_poker_session_poker_session_participant_path(params[:id])
    end
  end

  def new
    @view_model = PokerSessions::CreateModel.new
  end

  def edit
    if verify_poker_session_context(params[:id])
      @poker_session = PokerSession.find(params[:id])
      @view_model = PokerSessions::CreateModel.new(estimates: @poker_session.estimates)
    else
      redirect_to new_poker_session_poker_session_participant_path(params[:id])
    end
  end

  def update
    if verify_poker_session_context(params[:id])
      @view_model = PokerSessions::CreateModel.new(create_params)
      @poker_session = PokerSession.find(params[:id])

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
    else
      redirect_to new_poker_session_poker_session_participant_path(params[:id])
    end
  end

  def create
    @view_model = PokerSessions::CreateModel.new(create_params)

    if @view_model.valid?
      poker_sesion = PokerSession.create!(estimates: @view_model.estimates)

      redirect_to poker_session_path(poker_sesion), turbo_frame: "_top"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def toggle_estimates_visibility
    if verify_poker_session_context(params[:poker_session_id])
      poker_session = PokerSession.find(params[:poker_session_id])
      poker_session.toggle!(:show_estimates)

      Turbo::StreamsChannel.broadcast_update_to(
        "poker_session_#{params[:poker_session_id]}",
        partial: "poker_sessions/table",
        locals: {poker_session:},
        target: :table
      )
    else
      redirect_to new_poker_session_poker_session_participant_path(params[:poker_session_id])
    end
  end

  def delete_estimates
    if verify_poker_session_context(params[:poker_session_id])
      poker_session = PokerSession.find(params[:poker_session_id])

      ActiveRecord::Base.transaction do
        PokerSessionParticipantEstimate.where(poker_session_id: params[:poker_session_id]).destroy_all
        poker_session.update!(show_estimates: false)
      end

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
    else
      redirect_to new_poker_session_poker_session_participant_path(params[:poker_session_id])
    end
  end

  private def create_params
    params.require(:poker_session).permit(:estimates)
  end
end
