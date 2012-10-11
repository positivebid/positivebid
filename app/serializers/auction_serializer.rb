class AuctionSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :description, :location, :hashtag, :event_start_at, :event_end_at, :allow_anonymous_bids, :charity_name, :fundraising_target, :payment_methods, :created_at, :updated_at

  has_one :picture, :key => :picture_id

end
