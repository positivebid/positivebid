class AddTimeZoneToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :time_zone, :string, :default => 'London'
  end
end
