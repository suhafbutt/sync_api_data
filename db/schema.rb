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

ActiveRecord::Schema[7.1].define(version: 2025_07_28_234330) do
  create_table "github_org_users", force: :cascade do |t|
    t.integer "github_org_id", null: false
    t.integer "github_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_org_id", "github_user_id"], name: "index_github_org_users_on_github_org_id_and_github_user_id", unique: true
  end

  create_table "github_orgs", force: :cascade do |t|
    t.string "source_org_id", null: false
    t.string "name", null: false
    t.string "login"
    t.string "description"
    t.string "url"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_org_id"], name: "index_github_orgs_on_source_org_id", unique: true
  end

  create_table "github_users", force: :cascade do |t|
    t.string "source_user_id", null: false
    t.string "login"
    t.string "firstname"
    t.string "lastname"
    t.string "avatar_url"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_user_id"], name: "index_github_users_on_source_user_id", unique: true
  end

  add_foreign_key "github_org_users", "github_orgs"
  add_foreign_key "github_org_users", "github_users"
end
