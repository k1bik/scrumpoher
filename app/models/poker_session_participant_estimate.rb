# typed: strict

class PokerSessionParticipantEstimate < ApplicationRecord
  belongs_to :poker_session
  belongs_to :poker_session_participant

  validates_presence_of :value
end
