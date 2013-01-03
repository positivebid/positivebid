class UpdateLotStates < ActiveRecord::Migration
  def up
    Lot.where(:state => 'forsale').update_all(:state => 'open')
  end

  def down
    Lot.where(:state => 'open').update_all(:state => 'forsale')
  end
end
