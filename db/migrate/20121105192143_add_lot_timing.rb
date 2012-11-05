class AddLotTiming < ActiveRecord::Migration
  def up
    add_column :auctions, :default_lot_timing, :string, :default => 'scheduled', :null => false
    add_column :lots, :timing, :string, :default => 'scheduled', :null => false
    add_index :lots, :timing
    add_index :lots, [:state, :timing]
    
  end

  def down
    
    remove_index :lots, :column => [:state, :timing]
    remove_index :lots, :column => :timing
    remove_column :lots, :timing
    remove_column :auctions, :default_lot_timing
  end
end
