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

ActiveRecord::Schema.define(version: 20160715052302) do

  create_table "account_confirmation_credentials", force: :cascade do |t|
    t.integer  "account_id",   limit: 4
    t.string   "password",     limit: 255
    t.string   "token",        limit: 255
    t.datetime "confirmed_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "account_documents", force: :cascade do |t|
    t.string   "account_document_file_name",    limit: 255
    t.string   "account_document_content_type", limit: 255
    t.integer  "account_document_file_size",    limit: 4
    t.datetime "account_document_updated_at"
  end

  create_table "account_permissions", force: :cascade do |t|
    t.integer "account_id",           limit: 4
    t.string  "account_role",         limit: 7, default: "manager"
    t.boolean "read_accounts",        limit: 1, default: true
    t.boolean "manage_accounts",      limit: 1, default: true
    t.boolean "read_wallets",         limit: 1, default: true
    t.boolean "read_verifications",   limit: 1, default: true
    t.boolean "manage_verifications", limit: 1, default: true
    t.boolean "read_locations",       limit: 1, default: true
    t.boolean "manage_locations",     limit: 1, default: true
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "middle_initials",         limit: 255
    t.string   "email",                   limit: 255, default: "",     null: false
    t.string   "login",                   limit: 255
    t.string   "encrypted_password",      limit: 255, default: "",     null: false
    t.string   "phone",                   limit: 255
    t.string   "address",                 limit: 255
    t.string   "account_type",            limit: 7,   default: "user"
    t.boolean  "active",                  limit: 1,   default: true
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           limit: 4,   default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",      limit: 255
    t.string   "last_sign_in_ip",         limit: 255
    t.string   "confirmation_token",      limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",       limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "city_id",                 limit: 255
    t.string   "state_id",                limit: 255
    t.string   "country_id",              limit: 255
    t.string   "zip",                     limit: 255
    t.integer  "account_document_id",     limit: 4
    t.string   "pesel_number",            limit: 255
    t.string   "authy_id",                limit: 255
    t.datetime "last_sign_in_with_authy"
    t.boolean  "authy_enabled",           limit: 1,   default: false
    t.boolean  "temporary",               limit: 1,   default: true
    t.string   "aten_id",                 limit: 255
  end

  add_index "accounts", ["authy_id"], name: "index_accounts_on_authy_id", using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "cities", primary_key: "ID", force: :cascade do |t|
    t.string  "Name",        limit: 35, default: "", null: false
    t.string  "CountryCode", limit: 3,  default: "", null: false
    t.string  "District",    limit: 20, default: "", null: false
    t.integer "Population",  limit: 4,  default: 0,  null: false
  end

  create_table "countries", primary_key: "Code", force: :cascade do |t|
    t.string  "Name",              limit: 52, default: "",     null: false
    t.string  "Continent",         limit: 13, default: "Asia", null: false
    t.string  "Region",            limit: 26, default: "",     null: false
    t.float   "SurfaceArea",       limit: 24, default: 0.0,    null: false
    t.integer "IndepYear",         limit: 2
    t.integer "Population",        limit: 4,  default: 0,      null: false
    t.float   "LifeExpectancy",    limit: 24
    t.float   "GNP",               limit: 24
    t.float   "GNPOld",            limit: 24
    t.string  "LocalName",         limit: 45, default: "",     null: false
    t.string  "GovernmentForm",    limit: 45, default: "",     null: false
    t.string  "HeadOfState",       limit: 60
    t.integer "Capital",           limit: 4
    t.string  "Code2",             limit: 2,  default: "",     null: false
    t.boolean "backside_document", limit: 1,  default: false
    t.boolean "active",            limit: 1,  default: true
  end

  create_table "country_languages", id: false, force: :cascade do |t|
    t.string "CountryCode", limit: 3,  default: "",  null: false
    t.string "Language",    limit: 30, default: "",  null: false
    t.string "IsOfficial",  limit: 1,  default: "F", null: false
    t.float  "Percentage",  limit: 24, default: 0.0, null: false
  end

  create_table "headshot_photos", force: :cascade do |t|
    t.string   "description",        limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.integer  "capturable_id",      limit: 4
    t.string   "capturable_type",    limit: 255
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id",         limit: 4
  end

  add_index "headshot_photos", ["account_id"], name: "index_headshot_photos_on_account_id", using: :btree

  create_table "iamreal_account_ids", force: :cascade do |t|
    t.string   "iamreal_id", limit: 255
    t.integer  "account_id", limit: 4
    t.datetime "created_at"
  end

  add_index "iamreal_account_ids", ["iamreal_id"], name: "index_iamreal_account_ids_on_iamreal_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string "name",         limit: 255
    t.string "country_code", limit: 255
  end

  create_table "user_verifications", force: :cascade do |t|
    t.integer  "account_id",     limit: 4
    t.string   "status",         limit: 9
    t.string   "document_path",  limit: 255
    t.string   "video_path",     limit: 255
    t.string   "comment",        limit: 255, default: ""
    t.string   "verified_by",    limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "document_type",  limit: 255
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.date     "date_of_birth"
    t.string   "nationality",    limit: 255
    t.string   "country",        limit: 255
    t.string   "city",           limit: 255
    t.string   "zip",            limit: 255
    t.string   "home_address",   limit: 255
    t.string   "video_thumnail", limit: 255
    t.string   "pin",            limit: 255
    t.string   "email",          limit: 255
  end

  create_table "verifications", force: :cascade do |t|
    t.integer  "account_id",        limit: 4
    t.string   "verification_type", limit: 11
    t.string   "status",            limit: 9
    t.string   "cancel_reason",     limit: 255, default: ""
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "verifiers", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "verifiers", ["email"], name: "index_verifiers_on_email", unique: true, using: :btree
  add_index "verifiers", ["reset_password_token"], name: "index_verifiers_on_reset_password_token", unique: true, using: :btree

  create_table "wallet_confirmation_credentials", force: :cascade do |t|
    t.integer  "account_id",   limit: 4
    t.string   "login",        limit: 255
    t.string   "password",     limit: 255
    t.string   "token",        limit: 255
    t.datetime "confirmed_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.integer  "account_id", limit: 4
    t.string   "username",   limit: 255
    t.string   "password",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
