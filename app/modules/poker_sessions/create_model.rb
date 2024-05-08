# typed: true

module PokerSessions
  class CreateModel
    include ActiveModel::Model

    MAX_ESTIMATES_LENGTH = 50

    attr_accessor :estimates

    validates_presence_of :estimates
    validates_length_of :estimates, maximum: MAX_ESTIMATES_LENGTH
    validate :unique_estimates

    private def unique_estimates
      estimates_arr = estimates.split(",").map(&:strip)

      if estimates_arr != estimates_arr.uniq
        errors.add(:estimates, "должны быть уникальными")
      end
    end
  end
end
