class CreatePublicOwners < ActiveRecord::Migration
  def up
    create_table :public_owners do |t|
      t.timestamps
    end
  end

  def down
    drop_table :public_owners
  end
end
