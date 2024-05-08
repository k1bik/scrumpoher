# typed: strict

module PokerSessionParticipants
  class Service
    extend T::Sig

    sig { params(view_model: PokerSessionParticipants::CreateModel, session: ActionDispatch::Request::Session).void }
    def create_poker_session_participant!(view_model:, session:)
      ActiveRecord::Base.transaction do
        participant = PokerSessionParticipant.create!(
          name: view_model.name,
          poker_session_id: view_model.poker_session_id
        )

        session[:poker_sessions] ||= []
        session[:poker_sessions] = [] if session[:poker_sessions].size > 5

        context = session[:poker_sessions].find {  _1["poker_session_id"] == view_model.poker_session_id }

        if context
          context["participant_id"] = participant.id
        else
          session[:poker_sessions] << { poker_session_id: view_model.poker_session_id, participant_id: participant.id }
        end
      end
    end
  end
end
