# typed: true

module PokerSessions
  class CreateModel
    include ActiveModel::Model

    attr_accessor :name, :estimates

    validates_presence_of :name, :estimates
  end
end
