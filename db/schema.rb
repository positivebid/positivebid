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

ActiveRecord::Schema.define(:version => 20121218104835) do

  create_table "auctions", :force => true do |t|
    t.string   "name",                                                 :null => false
    t.text     "description"
    t.string   "location"
    t.datetime "event_start_at"
    t.datetime "event_end_at"
    t.datetime "default_sale_start_at"
    t.datetime "default_sale_end_at"
    t.string   "hashtag"
    t.integer  "user_id"
    t.string   "charity_name"
    t.string   "charity_contact_name"
    t.string   "charity_contact_email"
    t.string   "charity_contact_telephone"
    t.boolean  "charity_approved",            :default => false
    t.integer  "fundraising_target"
    t.boolean  "allow_anonymous_bids",        :default => false
    t.string   "state",                       :default => "draft",     :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.text     "log"
    t.string   "time_zone",                   :default => "London"
    t.string   "default_lot_timing",          :default => "scheduled", :null => false
    t.boolean  "manual_payment_accepted",     :default => false
    t.string   "manual_payment_instructions"
    t.boolean  "justgiving_payment_accepted", :default => false
    t.string   "justgiving_sdi_charity_id"
    t.string   "organiser_name"
    t.string   "organiser_email"
    t.string   "organiser_telephone"
  end

  add_index "auctions", ["event_start_at"], :name => "index_auctions_on_event_start_at"
  add_index "auctions", ["state"], :name => "index_auctions_on_state"
  add_index "auctions", ["user_id"], :name => "index_auctions_on_user_id"

  create_table "bids", :force => true do |t|
    t.integer  "lot_id",     :null => false
    t.integer  "user_id"
    t.integer  "amount",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bids", ["amount"], :name => "index_bids_on_amount"
  add_index "bids", ["lot_id", "amount"], :name => "index_bids_on_lot_id_and_amount", :unique => true
  add_index "bids", ["lot_id", "created_at"], :name => "index_bids_on_lot_id_and_created_at"
  add_index "bids", ["lot_id"], :name => "index_bids_on_lot_id"
  add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

  create_table "faqs", :force => true do |t|
    t.string   "owner_type",                             :null => false
    t.integer  "owner_id",                               :null => false
    t.string   "title",                                  :null => false
    t.boolean  "show_index",          :default => false
    t.text     "before_html"
    t.text     "after_html"
    t.boolean  "show_position"
    t.boolean  "show_answers_on_faq", :default => true
    t.boolean  "published",           :default => false
    t.string   "key",                                    :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "faqs", ["key"], :name => "index_faqs_on_key", :unique => true
  add_index "faqs", ["owner_id", "owner_type"], :name => "index_faqs_on_owner_id_and_owner_type"
  add_index "faqs", ["published"], :name => "index_faqs_on_published"

  create_table "helplinks", :force => true do |t|
    t.string   "key"
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "helplinks", ["key"], :name => "index_helplinks_on_key", :unique => true
  add_index "helplinks", ["user_id"], :name => "index_helplinks_on_user_id"

  create_table "items", :force => true do |t|
    t.integer  "lot_id",            :null => false
    t.string   "name",              :null => false
    t.integer  "position"
    t.text     "description"
    t.text     "terms"
    t.text     "collection_info"
    t.string   "donor_name"
    t.string   "donor_website_url"
    t.text     "donor_byline"
    t.text     "organiser_notes"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "items", ["lot_id", "position"], :name => "index_items_on_lot_id_and_position"
  add_index "items", ["lot_id"], :name => "index_items_on_lot_id"

  create_table "lots", :force => true do |t|
    t.integer  "auction_id",                               :null => false
    t.string   "name",                                     :null => false
    t.integer  "number",                                   :null => false
    t.integer  "position",                                 :null => false
    t.integer  "min_increment",   :default => 1,           :null => false
    t.integer  "current_bid_id"
    t.boolean  "paid",            :default => false
    t.integer  "sold_for"
    t.boolean  "sold",            :default => false
    t.string   "payment_method"
    t.boolean  "collected",       :default => false
    t.datetime "sale_start_at"
    t.datetime "sale_end_at"
    t.integer  "buy_now_price"
    t.string   "state",           :default => "draft"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.text     "log"
    t.datetime "sold_at"
    t.datetime "paid_at"
    t.string   "timing",          :default => "scheduled", :null => false
    t.datetime "actual_start_at"
    t.datetime "actual_end_at"
    t.integer  "cents_paid",      :default => 0
  end

  add_index "lots", ["auction_id", "number"], :name => "index_lots_on_auction_id_and_number"
  add_index "lots", ["auction_id", "position"], :name => "index_lots_on_auction_id_and_position"
  add_index "lots", ["auction_id", "sale_start_at"], :name => "index_lots_on_auction_id_and_sale_start_at"
  add_index "lots", ["auction_id", "state"], :name => "index_lots_on_auction_id_and_state"
  add_index "lots", ["auction_id"], :name => "index_lots_on_auction_id"
  add_index "lots", ["state", "timing"], :name => "index_lots_on_state_and_timing"
  add_index "lots", ["state"], :name => "index_lots_on_state"
  add_index "lots", ["timing"], :name => "index_lots_on_timing"

  create_table "pictures", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.binary   "image_file_data"
    t.string   "image_filename"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "image_format"
    t.integer  "creator_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "pictures", ["creator_id"], :name => "index_pictures_on_creator_id"
  add_index "pictures", ["owner_id", "owner_type"], :name => "index_pictures_on_owner_id_and_owner_type"

  create_table "posts", :force => true do |t|
    t.string   "title",                           :null => false
    t.text     "body",                            :null => false
    t.string   "author",                          :null => false
    t.datetime "published_at",                    :null => false
    t.boolean  "published",    :default => false, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "posts", ["published", "published_at"], :name => "index_posts_on_published_and_published_at"
  add_index "posts", ["published"], :name => "index_posts_on_published"
  add_index "posts", ["published_at"], :name => "index_posts_on_published_at"

  create_table "public_owners", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "faq_id",                        :null => false
    t.integer  "position",                      :null => false
    t.string   "title",                         :null => false
    t.text     "body"
    t.boolean  "published",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "questions", ["faq_id", "position", "published"], :name => "index_questions_on_faq_id_and_position_and_published"
  add_index "questions", ["faq_id"], :name => "index_questions_on_faq_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name",                             :null => false
    t.string   "last_name",                              :null => false
    t.string   "image_url"
    t.string   "time_zone",           :default => "UTC", :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.datetime "last_login_ip"
    t.datetime "activated_at"
    t.boolean  "active"
    t.boolean  "positive_admin",      :default => false
    t.string   "mobile_number"
    t.string   "telephone_number"
    t.boolean  "anonymous_bidder",    :default => false
    t.boolean  "bid_confirmation",    :default => true
    t.boolean  "share_confirmation",  :default => true
    t.boolean  "outbid_confirmation", :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
  add_index "users", ["positive_admin"], :name => "index_users_on_positive_admin"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"
  add_index "users", ["provider"], :name => "index_users_on_provider"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token", :unique => true

end
