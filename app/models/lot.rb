class Lot < ActiveRecord::Base
  USER_FIELDS = [
    :name, 
    :number, 
    :buy_now_price, 
    :min_increment, 
    :collected, 
    :published, 
    :sale_start_at,
    :sale_end_at
  ]
  
  ADMIN_ONLY_FIELDS = [ :paid, :payment_method ]
  ADMIN_FIELDS = USER_FIELDS + ADMIN_ONLY_FIELDS

  attr_accessible *USER_FIELDS
  attr_accessible *ADMIN_FIELDS, :as => :admin

  belongs_to :auction
  has_many :bids, :dependent => :destroy
  belongs_to :current_bid, :class_name => 'Bid'
  has_many :items, :dependent => :destroy

  validates_presence_of :name
  validates_inclusion_of :min_increment, :in => 1..100
  validates_numericality_of :buy_now_price, :greater_than_or_equal_to => 1, :allow_nil => true
  validates_length_of :name, :in => 2..255
  validates_uniqueness_of :number, :scope => :auction_id
  acts_as_list  :scope => :auction

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
