# typed: true

class PokerSession < ApplicationRecord
  has_many :poker_session_participants

  validates_presence_of :name, :estimates

  def self.add_to_session(session:, poker_session_id:, participant_id:)
    item = { poker_session_id: poker_session_id, participant_id: participant_id }
    session[:poker_sessions] ||= []
    session[:poker_sessions] << item
  end
end
