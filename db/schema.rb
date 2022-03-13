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

ActiveRecord::Schema[7.0].define(version: 2022_03_13_225242) do
  create_table "matches", force: :cascade do |t|
    t.integer "winner_id"
    t.string "winner_name"
    t.integer "loser_id"
    t.string "loser_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "nationality"
    t.string "dob"
    t.integer "points"
    t.integer "globalranking"
    t.integer "matchesplayed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rank"
  end

end
