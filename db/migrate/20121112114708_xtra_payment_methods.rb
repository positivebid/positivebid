class XtraPaymentMethods < ActiveRecord::Migration
  def up
    remove_column :auctions, :payment_methods
    add_column :auctions, :manual_payment_accepted, :boolean, :default => false
    add_column :auctions, :manual_payment_instructions, :string
    add_column :auctions, :justgiving_payment_accepted, :boolean, :default => false
    add_column :auctions, :justgiving_sdi_charity_id, :string
  end

  def down
    remove_column :auctions, :justgiving_sdi_charity_id
    remove_column :auctions, :justgiving_payment_accepted
    remove_column :auctions, :manual_payment_instructions
    remove_column :auctions, :manual_payment_accepted
    add_column :auctions, :payment_methods, :text
  end
end
