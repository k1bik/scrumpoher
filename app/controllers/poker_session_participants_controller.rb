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

      redirect_to poker_session_path(@view_model.poker_session_id), notice: "Успешно!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private def create_poker_session_participant_params
    params.require(:poker_session_participant).permit(:name)
  end
end
