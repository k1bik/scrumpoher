class CreatePokerSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :poker_sessions, id: :uuid do |t|
      t.string :estimates, null: false
      t.boolean :show_estimates, null: false, default: false

      t.timestamps
    end
  end
end
