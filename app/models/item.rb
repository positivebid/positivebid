class Item < ActiveRecord::Base
  USER_FIELDS = [ 
    :name, 
    :description, 
    :terms, 
    :collection_info, 
    :donor_name, 
    :donor_byline, 
    :organiser_notes 
  ]

  attr_accessible *USER_FIELDS

  belongs_to :lot

  acts_as_list :scope => :lot_id

  scope :sorted, :order => 'position ASC'

  include NodeventGlobal

  def self.order_by_ids(ids)
    transaction do
      ids.each_index do |i|
        find(ids[i]).update_column(:position, i+1)
      end
    end
  end



end
