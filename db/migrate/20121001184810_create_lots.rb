class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.integer :auction_id, :null => false
      t.string :name, :null => false
      t.integer :number, :null => false
      t.integer :position, :null => false
      t.integer :min_increment, :default => 1, :null => false
      t.integer :current_bid_id
      t.boolean :paid, :default => false
      t.integer :sold_for
      t.boolean :sold, :default => false
      t.string :payment_method
      t.text :payment_method
      t.boolean :collected, :default => false
      t.boolean :published, :default => false
      t.datetime :sale_start_at
      t.datetime :sale_end_at
      t.integer :buy_now_price
      t.string :state, :default => 'draft'

      t.timestamps
    end

    add_index :lots, :auction_id
    add_index :lots, [:auction_id, :position ]
    add_index :lots, [:auction_id, :number ]
    add_index :lots, [:auction_id, :sale_start_at ]
    add_index :lots, [:auction_id, :state ]
    add_index :lots, :state

  end
end
