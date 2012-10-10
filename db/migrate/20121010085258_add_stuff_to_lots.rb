class AddStuffToLots < ActiveRecord::Migration
  def change
    add_column :lots, :sold_at, :datetime
    add_column :lots, :paid_at, :datetime
  end
end
