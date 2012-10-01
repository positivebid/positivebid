class Lot < ActiveRecord::Base
  attr_accessible :buy_now_price, :collected, :min_increment, :name, :number, :paid, :payment_method, :payment_method, :published, :sale_end_at, :sale_start_at 

  belongs_to :auction
  has_many :bids, :dependent => :destroy
  has_many :items, :dependent => :destroy

  validates_presence_of :name
  validates_inclusion_of :min_increment, :in => 1..100
  validates_numericality_of :buy_now_price, :greater_than_or_equal_to => 1, :allow_nil => true
  validates_length_of :name, :in => 2..255
  validates_uniqueness_of :number, :scope => :auction_id
  acts_as_list  :scope => :auction

  scope :sorted, :order => 'position ASC'

  def self.order_by_ids(ids)
    transaction do
      ids.each_index do |i|
        find(ids[i]).update_column(:position, i+1)
      end
    end
  end


end
