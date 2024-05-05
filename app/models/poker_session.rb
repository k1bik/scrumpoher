# typed: true

class PokerSession < ApplicationRecord
  has_many :poker_session_participants

  validates_presence_of :name, :estimates
end
