# typed: true

class PokerSession < ApplicationRecord
  has_many :poker_session_participants

  validates_presence_of :name, :estimates

  def self.add_to_session(session:, poker_session_id:, participant_id:)
    item = { poker_session_id: poker_session_id, participant_id: participant_id }
    session[:poker_sessions] ||= []
    session[:poker_sessions] << item
  end

  def self.build_context(session:, poker_session_id:)
    item = session[:poker_sessions]&.find { _1["poker_session_id"] == poker_session_id }

    if item
      PokerSessions::Context.new(
        poker_session_id: item["poker_session_id"],
        participant_id: item["participant_id"]
      )
    else
      nil
    end
  end
end
