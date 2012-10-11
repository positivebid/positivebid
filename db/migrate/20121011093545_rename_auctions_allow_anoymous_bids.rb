class RenameAuctionsAllowAnoymousBids < ActiveRecord::Migration
  def up
    rename_column :auctions, :allow_anoymous_bids, :allow_anonymous_bids
  end

  def down
    rename_column :auctions, :allow_anonymous_bids, :allow_anoymous_bids
  end
end
