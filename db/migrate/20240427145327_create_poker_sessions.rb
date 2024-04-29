class CreatePokerSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :poker_sessions, id: :uuid do |t|
      t.string :name, null: false
      t.string :estimates, null: false

      t.timestamps
    end
  end
end
