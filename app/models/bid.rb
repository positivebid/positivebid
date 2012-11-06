class Bid < ActiveRecord::Base
  attr_accessible :amount, :lot_id

  belongs_to :lot
  belongs_to :user

  validates_presence_of :lot, :user, :amount
  validates_numericality_of :amount, :greater_than_or_equal_to => 0
  validate :check_greater
  validate :bidding_open

  include NodeventGlobal

  after_create :update_current_bid

  def check_greater
    if lot.current_bid and amount <= lot.current_bid.amount
      errors.add(:value, 'is not greater than the current bid')
      return false
    else
      return true
    end
  end

  def bidding_open
    if lot.bidable?
      return true
    else
      if lot.sold? or lot.paid? or lot.bought?
        errors.add(:base, 'Lot has been sold!')
      elsif lot.published?
        errors.add(:base, 'Lot Bidding not yet open')
      elsif lot.published?
        errors.add(:base, 'Bids not being accepted just now.')
      end
      return false
    end
  end

  def update_current_bid
    lot.current_bid = self
    lot.save
    return true
  end

end
