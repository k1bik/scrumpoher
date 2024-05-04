# typed: strict

class PokerSessionParticipant < ApplicationRecord
  belongs_to :poker_session
  has_one :poker_session_participant_estimate

  validates_presence_of :poker_session, :name
end
