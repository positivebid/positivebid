class Auction < ActiveRecord::Base

  USER_FIELDS = [ :name, 
    :description, 
    :location, 
    :time_zone,
    :hashtag, 
    :event_start_at, 
    :event_end_at, 
    :default_lot_timing,
    :default_sale_start_at, 
    :default_sale_end_at, 
    :allow_anonymous_bids, 
    :charity_contact_email, 
    :charity_contact_name, 
    :charity_contact_telephone, 
    :charity_name, 
    :charity_approved, 
    :fundraising_target, 
    :payment_methods ,
    :picture_attributes

  ]

  ADMIN_ONLY_FIELDS = [ :charity_approved ]
  ADMIN_FIELDS = USER_FIELDS + ADMIN_ONLY_FIELDS


  attr_accessible *USER_FIELDS
  attr_accessible *ADMIN_FIELDS, :as => :admin

  has_one :picture, as: :owner, dependent: :destroy, select: Picture::LITE_SELECT
  has_one :full_picture, as: :owner, class_name: 'Picture'
  accepts_nested_attributes_for :picture

  validates_presence_of :name
  validates_length_of :name, :in => 2..100
  validates_inclusion_of :default_lot_timing, :in => Lot::TIMINGS

  belongs_to :user  # the requestor 

  has_many :lots, :dependent => :destroy
  has_many :items, :through => :lots
  has_many :bids, :through => :lots

  include NodeventGlobal


end
