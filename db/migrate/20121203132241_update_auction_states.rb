class UpdateAuctionStates < ActiveRecord::Migration
  def up
    change_column :auctions, :state, :string, :default => 'draft'
    Auction.where(:state => 'requested').update_all(:state => 'draft')
  end

  def down
  end
end
