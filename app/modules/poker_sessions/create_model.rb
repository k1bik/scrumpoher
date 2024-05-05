# typed: true

module PokerSessions
  class CreateModel
    include ActiveModel::Model

    attr_accessor :estimates

    validates_presence_of :estimates
  end
end
