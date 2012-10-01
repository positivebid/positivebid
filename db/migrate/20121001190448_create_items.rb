class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :lot_id, :null => false
      t.string :name, :null => false
      t.integer :position
      t.text :description
      t.text :terms
      t.text :collection_info
      t.string :donor_name
      t.string :donor_website_url
      t.text :donor_byline
      t.text :organiser_notes

      t.timestamps
    end

    add_index :items, :lot_id
    add_index :items, [ :lot_id, :position ]

  end
end
