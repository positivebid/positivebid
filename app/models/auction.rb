class Auction < ActiveRecord::Base
  attr_accessible :allow_anoymous_bids, :charity_approved, :charity_contact_email, :charity_contact_name, :charity_contact_telephone, :charity_name, :default_sale_end_at, :default_sale_start_at, :description, :event_end_at, :event_start_at, :fundraising_target, :hashtag, :location, :name, :payment_methods, :user_id

  validates_presence_of :name
  validates_length_of :name, :in => 2..255

  belongs_to :user  # the requestor 

  has_many :lots, :dependent => :destroy
  has_many :items, :though => :lots
  has_many :bids, :though => :lots



end
