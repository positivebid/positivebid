class Item < ActiveRecord::Base
  USER_FIELDS = [ 
    :name, 
    :description, 
    :terms, 
    :collection_info, 
    :donor_name, 
    :donor_byline, 
    :organiser_notes,
    :picture_attributes
  ]

  attr_accessible *USER_FIELDS

  belongs_to :lot

  has_one :picture, as: :owner, dependent: :destroy, select: Picture::LITE_SELECT
  has_one :full_picture, as: :owner, class_name: 'Picture'
  accepts_nested_attributes_for :picture

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

  after_save -> { self.create_picture if self.picture.nil? }


end
