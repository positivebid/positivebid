class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :faq_id, :null => false
      t.integer :position, :null => false
      t.string :title, :null => false
      t.text :body
      t.boolean :published, :default => false

      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end

    add_index :questions, [:faq_id, :position, :published ]
    add_index :questions, :faq_id

  end
end
