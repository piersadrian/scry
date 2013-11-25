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

ActiveRecord::Schema.define(version: 20131125004636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_sets", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "block_id"
    t.datetime "release_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: true do |t|
    t.string   "name"
    t.string   "mana_cost"
    t.integer  "converted_cost", default: 0
    t.integer  "power"
    t.integer  "toughness"
    t.integer  "loyalty"
    t.string   "card_type"
    t.string   "subtype"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "editions", force: true do |t|
    t.string   "rarity"
    t.text     "flavor"
    t.integer  "set_number"
    t.string   "artist"
    t.string   "image_url"
    t.integer  "card_set_id"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mv_id"
  end

end
