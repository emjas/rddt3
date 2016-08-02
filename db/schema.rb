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

ActiveRecord::Schema.define(version: 20150929205051) do

  create_table "clans", primary_key: "clan_id", force: true do |t|
    t.string "abbreviation"
  end

  add_index "clans", ["abbreviation"], name: "index_clans_on_abbreviation", using: :btree

  create_table "members", id: false, force: true do |t|
    t.integer  "clan_id",    default: 0, null: false
    t.integer  "account_id", default: 0, null: false
    t.datetime "created_at"
    t.string   "role"
    t.string   "role_i18n"
  end

  create_table "player_tanks", id: false, force: true do |t|
    t.integer "account_id", default: 0, null: false
    t.integer "tank_id",    default: 0, null: false
  end

  create_table "players", primary_key: "account_id", force: true do |t|
    t.string   "nickname"
    t.string   "reddit_name"
    t.datetime "last_battle_time"
    t.datetime "created_at"
  end

  create_table "recorded_resources", id: false, force: true do |t|
    t.integer  "player_id",             default: 0, null: false
    t.datetime "created_at",                        null: false
    t.integer  "count"
    t.float    "slope_prev", limit: 24
    t.datetime "deleted_at"
  end

  create_table "tanks", primary_key: "tank_id", force: true do |t|
    t.integer "level"
    t.string  "name_i18n"
  end

end
