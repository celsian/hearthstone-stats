# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131116202003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arenas", force: true do |t|
    t.string   "hero"
    t.boolean  "complete"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "arenas", ["user_id"], name: "index_arenas_on_user_id", using: :btree

  create_table "matches", force: true do |t|
    t.integer  "arena_id"
    t.boolean  "win"
    t.string   "enemy"
    t.boolean  "first"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["arena_id"], name: "index_matches_on_arena_id", using: :btree

  create_table "stats", force: true do |t|
    t.integer  "user_id"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "winrate_when_first_wins"
    t.integer  "winrate_when_first_losses"
    t.integer  "winrate_when_second_wins"
    t.integer  "winrate_when_second_losses"
    t.integer  "total_series"
    t.integer  "profitable_series"
    t.integer  "nine0"
    t.integer  "ninex"
    t.integer  "xthree"
    t.integer  "zerothree"
    t.integer  "wr_as_druid_wins"
    t.integer  "wr_as_druid_losses"
    t.integer  "wr_as_hunter_wins"
    t.integer  "wr_as_hunter_losses"
    t.integer  "wr_as_mage_wins"
    t.integer  "wr_as_mage_losses"
    t.integer  "wr_as_paladin_wins"
    t.integer  "wr_as_paladin_losses"
    t.integer  "wr_as_priest_wins"
    t.integer  "wr_as_priest_losses"
    t.integer  "wr_as_shaman_wins"
    t.integer  "wr_as_shaman_losses"
    t.integer  "wr_as_rogue_wins"
    t.integer  "wr_as_rogue_losses"
    t.integer  "wr_as_warlock_wins"
    t.integer  "wr_as_warlock_losses"
    t.integer  "wr_as_warrior_wins"
    t.integer  "wr_as_warrior_losses"
    t.integer  "wr_against_druid_wins"
    t.integer  "wr_against_druid_losses"
    t.integer  "wr_against_hunter_wins"
    t.integer  "wr_against_hunter_losses"
    t.integer  "wr_against_mage_wins"
    t.integer  "wr_against_mage_losses"
    t.integer  "wr_against_paladin_wins"
    t.integer  "wr_against_paladin_losses"
    t.integer  "wr_against_priest_wins"
    t.integer  "wr_against_priest_losses"
    t.integer  "wr_against_shaman_wins"
    t.integer  "wr_against_shaman_losses"
    t.integer  "wr_against_rogue_wins"
    t.integer  "wr_against_rogue_losses"
    t.integer  "wr_against_warlock_wins"
    t.integer  "wr_against_warlock_losses"
    t.integer  "wr_against_warrior_wins"
    t.integer  "wr_against_warrior_losses"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stats", ["user_id"], name: "index_stats_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
