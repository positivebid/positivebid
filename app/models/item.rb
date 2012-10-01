class Item < ActiveRecord::Base
  attr_accessible :collection_info, :description, :donor_byline, :donor_name, :name, :terms, :organiser_notes

  belongs_to :lot

  acts_as_list :scope => :lot_id

  scope :sorted, :order => 'position ASC'

  def self.order_by_ids(ids)
    transaction do
      ids.each_index do |i|
        find(ids[i]).update_column(:position, i+1)
      end
    end
  end


end
