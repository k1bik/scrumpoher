# typed: true

module PokerSessionParticipants
  class CreateModel
    include ActiveModel::Model

    attr_accessor :name, :poker_session_id

    validates_presence_of :name, :poker_session_id
  end
end
