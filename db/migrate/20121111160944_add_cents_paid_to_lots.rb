class AddCentsPaidToLots < ActiveRecord::Migration
  def change
    add_column :lots, :cents_paid, :integer, :default => 0
  end
end
