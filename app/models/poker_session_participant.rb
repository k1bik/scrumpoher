# typed: true

class PokerSessionParticipant < ApplicationRecord
  belongs_to :poker_session

  has_one :poker_session_participant_estimate, dependent: :destroy

  scope :active, -> { where(active: true) }

  validates_presence_of :poker_session, :name

  def inactive?
    !active
  end

  def active?
    active
  end
end
