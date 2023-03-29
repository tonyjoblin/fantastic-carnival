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

ActiveRecord::Schema[7.0].define(version: 2023_03_29_045047) do
  create_table "guests", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
  end

  create_table "phones", force: :cascade do |t|
    t.string "number", null: false
    t.integer "guest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_phones_on_guest_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.string "code", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "nights"
    t.integer "guests"
    t.integer "adults"
    t.integer "children"
    t.integer "infants"
    t.string "status"
    t.string "currency", limit: 3
    t.decimal "security_deposit", precision: 10, scale: 2
    t.decimal "payout_amount", precision: 10, scale: 2
    t.decimal "total_paid", precision: 10, scale: 2
    t.integer "guest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source", null: false
    t.index ["code"], name: "index_reservations_on_code", unique: true
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
    t.index ["start_date"], name: "index_reservations_on_start_date"
    t.index ["status"], name: "index_reservations_on_status"
  end

  add_foreign_key "phones", "guests"
  add_foreign_key "reservations", "guests"
end
