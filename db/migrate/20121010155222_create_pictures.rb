class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :owner_id
      t.string :owner_type
      t.binary :image_file_data
      t.string :image_filename
      t.integer :image_width
      t.integer :image_height
      t.string :image_format
      t.integer :creator_id

      t.timestamps
    end

    add_index :pictures, :creator_id
    add_index :pictures, [ :owner_id, :owner_type ]
  end
end
