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

ActiveRecord::Schema.define(version: 2021_04_16_215521) do

  create_table "houses", id: :string, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "personal_information_id", collation: "utf8_bin"
    t.string "ownership_status"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_houses_on_deleted_at"
  end

  create_table "personal_informations", id: :string, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "age"
    t.integer "dependents"
    t.integer "income"
    t.string "marital_status"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_personal_informations_on_deleted_at"
  end

  create_table "risk_questions", id: :string, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "personal_information_id", collation: "utf8_bin"
    t.boolean "question1"
    t.boolean "question2"
    t.boolean "question3"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_risk_questions_on_deleted_at"
  end

  create_table "vehicles", id: :string, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "personal_information_id", collation: "utf8_bin"
    t.integer "year"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_vehicles_on_deleted_at"
  end

end
