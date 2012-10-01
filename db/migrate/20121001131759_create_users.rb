class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null =>false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :image_url
      t.string :time_zone, :default => 'UTC', :null => false
      t.string :crypted_password, :null =>false
      t.string :password_salt, :null =>false
      t.string :persistence_token, :null =>false
      t.string :single_access_token, :null =>false
      t.string :perishable_token, :null =>false
      t.integer :login_count, :default => 0, :null => false
      t.integer :failed_login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.datetime :last_login_ip
      t.datetime :activated_at
      t.boolean :active
      t.boolean :positive_admin, :default => false
      t.string :mobile_number
      t.string :telephone_number
      t.boolean :anonymous_bidder, :default => false
      t.boolean :bid_confirmation, :default => true
      t.boolean :share_confirmation, :default => true
      t.boolean :outbid_confirmation, :default => true

      t.timestamps
    end

    add_index :users, :email, :unique => true
    add_index :users, :single_access_token, :unique => true
    add_index :users, :perishable_token, :unique => true
    add_index :users, :persistence_token, :unique => true
    add_index :users, :positive_admin

  end
end
