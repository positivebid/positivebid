class LogMove < ActiveRecord::Migration
  def up
     remove_column :bids, :log
     add_column :lots, :log, :text
  end

  def down
     add_column :bids, :log, :text
     remove_column :lots, :log
  end
end
