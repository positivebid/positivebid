class AllowNullEmailsOnUers < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, :null => true
    change_column :users, :crypted_password, :string, :null => true
    change_column :users, :password_salt, :string, :null => true
  end

  def down
    change_column :users, :email, :string, :null => false
    change_column :users, :crypted_password, :string, :null => false
    change_column :users, :password_salt, :string, :null => false
  end
end
