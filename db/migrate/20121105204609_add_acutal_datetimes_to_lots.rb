class AddAcutalDatetimesToLots < ActiveRecord::Migration
  def change
    add_column :lots, :actual_start_at, :datetime
    add_column :lots, :actual_end_at, :datetime
  end
end
