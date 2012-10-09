class AddLogToVariousModels < ActiveRecord::Migration
  def change

    add_column :auctions, :log, :text
    add_column :bids, :log, :text

  end
end
