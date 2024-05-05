# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_29_190206) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "poker_session_participant_estimates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "poker_session_id", null: false
    t.uuid "poker_session_participant_id", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poker_session_id"], name: "index_poker_session_participant_estimates_on_poker_session_id"
    t.index ["poker_session_participant_id"], name: "idx_on_poker_session_participant_id_aee26f506b"
  end

  create_table "poker_session_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "poker_session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poker_session_id"], name: "index_poker_session_participants_on_poker_session_id"
  end

  create_table "poker_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "estimates", null: false
    t.boolean "show_estimates", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "poker_session_participant_estimates", "poker_session_participants"
  add_foreign_key "poker_session_participant_estimates", "poker_sessions"
  add_foreign_key "poker_session_participants", "poker_sessions"
end
