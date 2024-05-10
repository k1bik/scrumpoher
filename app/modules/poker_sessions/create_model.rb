# typed: true

module PokerSessions
  class CreateModel
    include ActiveModel::Model

    MAX_ESTIMATES_LENGTH = 50

    attr_accessor :estimates

    validates_presence_of :estimates, message: "не могут отсутствовать"
    validates_length_of :estimates, maximum: MAX_ESTIMATES_LENGTH
    validate :unique_estimates, :no_empty_estimates

    private def unique_estimates
      estimates_arr = estimates.split(",").map(&:strip)

      if estimates_arr != estimates_arr.uniq
        errors.add(:estimates, "должны быть уникальными")
      end
    end

    private def no_empty_estimates
      if estimates.split(",").any?(&:blank?)
        errors.add(:estimates, "должны быть заполнены")
      end
    end
  end
end
