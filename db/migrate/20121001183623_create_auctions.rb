class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :name, :null => false
      t.text :description
      t.string :location
      t.datetime :event_start_at
      t.datetime :event_end_at
      t.datetime :default_sale_start_at
      t.datetime :default_sale_end_at
      t.string :hashtag
      t.integer :user_id
      t.string :charity_name
      t.string :charity_contact_name
      t.string :charity_contact_email
      t.string :charity_contact_telephone
      t.boolean :charity_approved, :default => false
      t.integer :fundraising_target
      t.text :payment_methods
      t.boolean :allow_anoymous_bids, :default => false
      t.string :state, :default => 'requested', :null => false

      t.timestamps
    end

    add_index :auctions, :user_id
    add_index :auctions, :state
    add_index :auctions, :event_start_at
  end
end
