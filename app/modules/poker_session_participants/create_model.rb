# typed: true

module PokerSessionParticipants
  class CreateModel
    include ActiveModel::Model

    MAX_NAME_LENGTH = 50

    attr_accessor :name, :poker_session_id

    validates_presence_of :name, :poker_session_id
    validates_length_of :name, maximum: MAX_NAME_LENGTH
  end
end
