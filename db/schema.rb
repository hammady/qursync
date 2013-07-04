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

ActiveRecord::Schema.define(:version => 20130704113337) do

  create_table "bookmarks", :force => true do |t|
    t.string   "name"
    t.integer  "page"
    t.integer  "sura"
    t.integer  "aya"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_default", :default => false
  end

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 40
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "oauth2_access_tokens", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "refresh_token_id"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "oauth2_access_tokens", ["client_id"], :name => "index_oauth2_access_tokens_on_client_id"
  add_index "oauth2_access_tokens", ["expires_at"], :name => "index_oauth2_access_tokens_on_expires_at"
  add_index "oauth2_access_tokens", ["token"], :name => "index_oauth2_access_tokens_on_token", :unique => true
  add_index "oauth2_access_tokens", ["user_id"], :name => "index_oauth2_access_tokens_on_user_id"

  create_table "oauth2_authorization_codes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "oauth2_authorization_codes", ["client_id"], :name => "index_oauth2_authorization_codes_on_client_id"
  add_index "oauth2_authorization_codes", ["expires_at"], :name => "index_oauth2_authorization_codes_on_expires_at"
  add_index "oauth2_authorization_codes", ["token"], :name => "index_oauth2_authorization_codes_on_token", :unique => true
  add_index "oauth2_authorization_codes", ["user_id"], :name => "index_oauth2_authorization_codes_on_user_id"

  create_table "oauth2_clients", :force => true do |t|
    t.string   "name"
    t.string   "redirect_uri"
    t.string   "website"
    t.string   "identifier"
    t.string   "secret"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "oauth2_clients", ["identifier"], :name => "index_oauth2_clients_on_identifier", :unique => true

  create_table "oauth2_refresh_tokens", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "oauth2_refresh_tokens", ["client_id"], :name => "index_oauth2_refresh_tokens_on_client_id"
  add_index "oauth2_refresh_tokens", ["expires_at"], :name => "index_oauth2_refresh_tokens_on_expires_at"
  add_index "oauth2_refresh_tokens", ["token"], :name => "index_oauth2_refresh_tokens_on_token", :unique => true
  add_index "oauth2_refresh_tokens", ["user_id"], :name => "index_oauth2_refresh_tokens_on_user_id"

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 40
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.string   "scope"
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "expires_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
