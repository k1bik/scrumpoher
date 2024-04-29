class CreatePokerSessionParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :poker_session_participants, id: :uuid do |t|
      t.string :name, null: false
      t.belongs_to :poker_session, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
