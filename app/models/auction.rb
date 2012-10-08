class Auction < ActiveRecord::Base

  USER_FIELDS = [ :name, 
    :description, 
    :location, 
    :hashtag, 
    :event_start_at, 
    :event_end_at, 
    :default_sale_start_at, 
    :default_sale_end_at, 
    :allow_anoymous_bids, 
    :charity_contact_email, 
    :charity_contact_name, 
    :charity_contact_telephone, 
    :charity_name, 
    :charity_approved, 
    :fundraising_target, 
    :payment_methods ]

  ADMIN_ONLY_FIELDS = [ :charity_approved ]
  ADMIN_FIELDS = USER_FIELDS + ADMIN_ONLY_FIELDS

  attr_accessible *USER_FIELDS
  attr_accessible *ADMIN_FIELDS, :as => :admin

  validates_presence_of :name
  validates_length_of :name, :in => 2..255

  belongs_to :user  # the requestor 

  has_many :lots, :dependent => :destroy
  has_many :items, :through => :lots
  has_many :bids, :through => :lots

  include NodeventGlobal


end
