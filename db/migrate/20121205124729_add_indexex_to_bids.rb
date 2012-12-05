class AddIndexexToBids < ActiveRecord::Migration
  def change
    add_index :bids, [:amount]
    add_index :bids, [:lot_id, :amount], :unique => true
  end
end
