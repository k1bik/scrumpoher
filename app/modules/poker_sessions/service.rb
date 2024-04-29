# typed: strict

module PokerSessions
  class Service
    extend T::Sig

    sig { params(view_model: PokerSessions::CreateModel).returns(PokerSession) }
    def create_poker_session!(view_model)
      PokerSession.create!(name: view_model.name, estimates: view_model.estimates)
    end
  end
end
