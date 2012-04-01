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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120401155344) do

  create_table "actannuals", :force => true do |t|
    t.float    "year_0"
    t.float    "year_1"
    t.float    "year_2"
    t.float    "year_3"
    t.float    "year_4"
    t.float    "year_5"
    t.float    "year_6"
    t.float    "year_7"
    t.float    "year_8"
    t.float    "year_9"
    t.float    "year_10"
    t.integer  "scenario_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "actborrowings", :force => true do |t|
    t.float    "size"
    t.float    "coupon"
    t.integer  "issue_year"
    t.integer  "maturity_year"
    t.string   "fixed_float"
    t.integer  "scenario_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "currency",      :default => "EUR"
    t.integer  "top_borrowing"
  end

  create_table "actcurrencies", :force => true do |t|
    t.string   "currency_name"
    t.float    "year_0"
    t.float    "year_1"
    t.float    "year_2"
    t.float    "year_3"
    t.float    "year_4"
    t.float    "year_5"
    t.integer  "actannual_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "annuals", :force => true do |t|
    t.float    "year_0"
    t.float    "year_1"
    t.float    "year_2"
    t.float    "year_3"
    t.float    "year_4"
    t.float    "year_5"
    t.float    "year_6"
    t.float    "year_7"
    t.float    "year_8"
    t.float    "year_9"
    t.float    "year_10"
    t.integer  "basecase_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "basecases", :force => true do |t|
    t.string   "name",       :default => "Core data"
    t.string   "group_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "borrowings", :force => true do |t|
    t.float    "size"
    t.float    "coupon"
    t.integer  "issue_year"
    t.integer  "maturity_year"
    t.string   "fixed_float"
    t.integer  "basecase_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "currency"
  end

  create_table "currencies", :force => true do |t|
    t.string   "currency_name"
    t.float    "year_0"
    t.float    "year_1"
    t.float    "year_2"
    t.float    "year_3"
    t.float    "year_4"
    t.float    "year_5"
    t.integer  "annual_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "forwardcurves", :force => true do |t|
    t.string   "currency"
    t.float    "term"
    t.float    "year_0"
    t.float    "year_1"
    t.float    "year_2"
    t.float    "year_3"
    t.float    "year_4"
    t.float    "year_5"
    t.float    "year_6"
    t.float    "year_7"
    t.float    "year_8"
    t.float    "year_9"
    t.float    "year_10"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fxrates", :force => true do |t|
    t.string   "currency_pair"
    t.float    "rate_year_0"
    t.float    "rate_year_1"
    t.float    "rate_year_2"
    t.float    "rate_year_3"
    t.float    "rate_year_4"
    t.float    "rate_year_5"
    t.float    "volatility"
    t.float    "correlation"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "group_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "project_name"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "swapcurves", :force => true do |t|
    t.string   "currency"
    t.float    "year_0"
    t.float    "year_1"
    t.float    "year_2"
    t.float    "year_3"
    t.float    "year_4"
    t.float    "year_5"
    t.float    "year_6"
    t.float    "year_7"
    t.float    "year_8"
    t.float    "year_9"
    t.float    "year_10"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.integer  "group_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["group_id"], :name => "index_users_on_group_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
