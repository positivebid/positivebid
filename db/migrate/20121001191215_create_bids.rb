class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :lot_id, :null => false
      t.integer :user_id
      t.integer :amount, :null => false

      t.timestamps
    end

    add_index :bids, :lot_id
    add_index :bids, :user_id
    add_index :bids, [:lot_id, :created_at]
  end
end
