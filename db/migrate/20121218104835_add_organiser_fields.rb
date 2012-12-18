class AddOrganiserFields < ActiveRecord::Migration
  def up
    add_column :auctions, :organiser_name, :string
    add_column :auctions, :organiser_email, :string
    add_column :auctions, :organiser_telephone, :string
  end

  def down
    remove_column :auctions, :organiser_telephone
    remove_column :auctions, :organiser_email
    remove_column :auctions, :organiser_name
  end
end
