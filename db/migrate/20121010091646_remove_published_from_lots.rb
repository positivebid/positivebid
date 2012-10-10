class RemovePublishedFromLots < ActiveRecord::Migration
  def up
    remove_column :lots, :published
  end

  def down
    add_column :lots, :published, :boolean, :default => false
  end
end
