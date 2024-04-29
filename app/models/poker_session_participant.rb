# typed: strict

class PokerSessionParticipant < ApplicationRecord
  belongs_to :poker_session

  validates_presence_of :poker_session, :name
end
