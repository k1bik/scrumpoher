class CreatePokerSessionParticipantEstimates < ActiveRecord::Migration[7.1]
  def change
    create_table :poker_session_participant_estimates, id: :uuid do |t|
      t.belongs_to :poker_session, null: false, foreign_key: true, type: :uuid
      t.belongs_to :poker_session_participant, null: false, foreign_key: true, type: :uuid
      t.string :value, null: false

      t.timestamps
    end
  end
end
