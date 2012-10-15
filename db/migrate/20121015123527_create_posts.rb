class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, :null => false
      t.text :body, :null => false
      t.string :author, :null => false
      t.datetime :published_at, :null => false
      t.boolean :published, :null => false, :default => false

      t.timestamps
    end

    add_index :posts, :published
    add_index :posts, :published_at
    add_index :posts, [:published, :published_at ]
  end
end
