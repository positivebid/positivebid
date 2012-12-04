class CreateHelplinks < ActiveRecord::Migration
  def change
    create_table :helplinks do |t|
      t.string :key
      t.string :title
      t.text :content
      t.integer :user_id

      t.timestamps
    end
    add_index :helplinks, :key, :unique => true
    add_index :helplinks, :user_id
  end
end
