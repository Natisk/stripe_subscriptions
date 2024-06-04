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

ActiveRecord::Schema[7.1].define(version: 2024_06_04_164334) do
  create_table "invoices", force: :cascade do |t|
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.string "account_country"
    t.decimal "amount_due"
    t.decimal "amount_paid"
    t.decimal "amount_remaining"
    t.decimal "amount_shipping"
    t.string "billing"
    t.string "charge"
    t.string "currency"
    t.boolean "paid", default: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
