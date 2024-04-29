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

        PokerSession.add_to_session(
          session:,
          poker_session_id: view_model.poker_session_id,
          participant_id: participant.id
        )
      end
    end
  end
end
