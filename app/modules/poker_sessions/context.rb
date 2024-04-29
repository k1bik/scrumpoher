# typed: strict

module PokerSessions
  class Context < T::Struct
    extend T::Sig

    const :participant_id, String
    const :poker_session_id, String
  end
end
