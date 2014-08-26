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

ActiveRecord::Schema.define(version: 20140727091138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "attachments", force: true do |t|
    t.integer  "matter_id"
    t.text     "guid"
    t.datetime "last_modified_utc"
    t.text     "row_version"
    t.text     "name"
    t.text     "hyperlink"
    t.text     "filename"
    t.text     "matter_version"
    t.boolean  "is_hyperlink"
    t.binary   "binary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "council_districts", id: false, force: true do |t|
    t.string   "name"
    t.string   "twit_name"
    t.string   "twit_wdgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",       limit: {:srid=>0, :type=>"geometry"}
    t.integer  "id",                                               null: false
  end

  create_table "event_items", force: true do |t|
    t.integer  "council_district_id"
    t.integer  "event_id"
    t.integer  "matter_id"
    t.integer  "source_id"
    t.string   "guid"
    t.datetime "last_modified"
    t.datetime "last_modified_utc"
    t.string   "row_version"
    t.integer  "agenda_sequence"
    t.integer  "minutes_sequence"
    t.string   "agenda_number"
    t.string   "video"
    t.integer  "video_index"
    t.string   "version"
    t.string   "agenda_note"
    t.string   "minutes_note"
    t.integer  "action_id"
    t.text     "action_name"
    t.text     "action_text"
    t.integer  "passed_flag"
    t.string   "passed_flag_name"
    t.integer  "roll_call_flag"
    t.string   "flag_extra"
    t.text     "title"
    t.string   "tally"
    t.integer  "consent"
    t.integer  "mover_id"
    t.string   "mover"
    t.integer  "seconder_id"
    t.string   "seconder"
    t.string   "matter_guid"
    t.string   "matter_file"
    t.string   "matter_name"
    t.string   "matter_type"
    t.string   "matter_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "guid"
    t.string   "last_modified"
    t.string   "last_modified_utc"
    t.string   "row_version"
    t.integer  "body_id"
    t.string   "body_name"
    t.datetime "date"
    t.string   "time"
    t.string   "video_status"
    t.integer  "agenda_status_id"
    t.integer  "minutes_status_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matters", force: true do |t|
    t.integer  "guid"
    t.datetime "last_modified_utc"
    t.string   "row_version"
    t.string   "file"
    t.string   "name"
    t.text     "title"
    t.integer  "type_id"
    t.string   "type_name"
    t.integer  "status_id"
    t.string   "status_name"
    t.integer  "body_id"
    t.text     "body_name"
    t.datetime "intro_date"
    t.datetime "agenda_date"
    t.datetime "passed_date"
    t.datetime "enactment_date"
    t.integer  "enactment_number"
    t.string   "requester"
    t.text     "notes"
    t.string   "version"
    t.text     "text1"
    t.text     "text2"
    t.text     "text3"
    t.text     "text4"
    t.text     "text5"
    t.datetime "date1"
    t.datetime "date2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
