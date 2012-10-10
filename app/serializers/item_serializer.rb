class ItemSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :lot_id, :name, :position, :description, :terms, :collection_info, :donor_name, :donor_website_url, :donor_byline, :created_at, :updated_at

  has_one :picture, :key => :picture_id

end
