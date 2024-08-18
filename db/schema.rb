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

ActiveRecord::Schema[7.2].define(version: 2024_08_18_195719) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "complaints", force: :cascade do |t|
    t.string "product"
    t.text "complain_what_happened"
    t.string "issue"
    t.string "sub_product"
    t.string "zip_code"
    t.string "tags"
    t.string "complaint_id"
    t.string "timely"
    t.string "consumer_consent_provided"
    t.string "company_response"
    t.string "submitted_via"
    t.string "company"
    t.datetime "date_received"
    t.string "state"
    t.string "consumer_disputed"
    t.text "company_public_response"
    t.string "sub_issue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.vector "embedding", limit: 1536
    t.boolean "is_user_created", default: false, null: false
    t.text "gpt_response"
    t.index ["is_user_created"], name: "index_complaints_on_is_user_created"
  end
end
