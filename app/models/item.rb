class Item < ActiveRecord::Base
  USER_FIELDS = [ :collection_info, :description, :donor_byline, :donor_name, :name, :terms, :organiser_notes ]

  attr_accessible *USER_FIELDS

  belongs_to :lot

  acts_as_list :scope => :lot_id

  after_create :emit_create
  after_update :emit_update

  scope :sorted, :order => 'position ASC'

  def self.order_by_ids(ids)
    transaction do
      ids.each_index do |i|
        find(ids[i]).update_column(:position, i+1)
      end
    end
  end


  def emit_create
    NoDevent::Emitter.emit('global_room', 'items:create', self )
  end

  def emit_update
    NoDevent::Emitter.emit('global_room', "item/#{id}:update", self )
  end


end
