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

ActiveRecord::Schema.define(version: 2020_01_24_121201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.decimal "job_id", null: false
    t.string "occupation", limit: 50, null: false
    t.string "email", limit: 50, null: false
    t.string "number", limit: 20, null: false
    t.string "address", limit: 200
    t.string "status", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title", limit: 50, null: false
    t.string "work_type", limit: 50, null: false
    t.decimal "salary", precision: 10, scale: 2, null: false
    t.decimal "openings", null: false
    t.date "start_date", null: false
    t.string "reporting_to", limit: 50, null: false
    t.string "status", limit: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
