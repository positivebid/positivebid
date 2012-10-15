class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :owner_type, :null => false
      t.integer :owner_id, :null => false
      t.string :title, :null => false
      t.boolean :show_index, :default => false
      t.text :before_html
      t.text :after_html
      t.boolean :show_position, :defalt => true
      t.boolean :show_answers_on_faq, :default => true
      t.boolean :published, :default => false
      t.string :key, :null => false

      t.timestamps
    end

    add_index :faqs, :key, :unique => true
    add_index :faqs, [:owner_id, :owner_type ]
    add_index :faqs, :published

  end
end
