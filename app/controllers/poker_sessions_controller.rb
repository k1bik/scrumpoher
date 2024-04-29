# typed: true

class PokerSessionsController < ApplicationController
  def index
  end

  def show
    poker_session_id = params[:id]
    @poker_session = PokerSession.find poker_session_id
    poker_session_context = PokerSession.build_context(session:, poker_session_id:)

    if poker_session_context
      render :show
    else
      redirect_to new_poker_session_poker_session_participant_path(poker_session_id)
    end
  end

  def new
    @view_model = PokerSessions::CreateModel.new
  end

  def create
    @view_model = PokerSessions::CreateModel.new(create_poker_session_params)

    if @view_model.valid?
      poker_sesion = PokerSessions::Service.new.create_poker_session!(@view_model)

      redirect_to poker_session_path(poker_sesion), nottice: "Успешно создано!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private def create_poker_session_params
    params.require(:poker_session).permit(:name, :estimates)
  end
end
