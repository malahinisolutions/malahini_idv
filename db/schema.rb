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

ActiveRecord::Schema.define(version: 20150110085304) do

  create_table "accounts", force: :cascade do |t|
    t.string   "login",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",              limit: 255, default: ""
    t.string   "phone_number",       limit: 255, default: ""
    t.string   "encrypted_password", limit: 255, default: ""
    t.string   "first_name",         limit: 255
    t.string   "last_name",          limit: 255
    t.boolean  "active",             limit: 1,   default: true
    t.string   "status",             limit: 9
    t.string   "middle_initials",    limit: 255
    t.string   "company_name",       limit: 255
    t.string   "zip",                limit: 255
    t.string   "address",            limit: 255
    t.string   "address2",           limit: 255
    t.integer  "city_id",            limit: 4
    t.integer  "state_id",           limit: 4
    t.integer  "country_id",         limit: 4
    t.integer  "external_id",        limit: 4
  end

  add_index "accounts", ["login"], name: "index_accounts_on_login", unique: true, using: :btree

  create_table "admin_accounts", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_accounts", ["email"], name: "index_admin_accounts_on_email", unique: true, using: :btree
  add_index "admin_accounts", ["reset_password_token"], name: "index_admin_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "api_accounts", force: :cascade do |t|
    t.integer  "account_id",       limit: 4
    t.integer  "server_pubkey_id", limit: 4
    t.string   "client_pubkey",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.string  "abbreviation", limit: 255
    t.integer "country_id",   limit: 4
    t.integer "state_id",     limit: 4
  end

  create_table "countries", force: :cascade do |t|
    t.string "name",         limit: 255
    t.string "abbreviation", limit: 255
  end

  create_table "server_pubkeys", force: :cascade do |t|
    t.string   "key",             limit: 255
    t.datetime "expiration_date"
    t.datetime "created_at"
  end

  add_index "server_pubkeys", ["key"], name: "index_server_pubkeys_on_key", using: :btree

  create_table "states", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.string  "abbreviation", limit: 255
    t.integer "country_id",   limit: 4
  end

end
