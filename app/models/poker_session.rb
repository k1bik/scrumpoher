# typed: true

class PokerSession < ApplicationRecord
  has_many :poker_session_participants, dependent: :destroy

  validates_presence_of :estimates
end
