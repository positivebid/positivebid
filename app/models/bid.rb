class Bid < ActiveRecord::Base
  attr_accessible :amount, :lot_id

  belongs_to :lot
  belongs_to :user

  validates_presence_of :lot, :user, :amount
  validates_numericality_of :amount, :greater_than_or_equal_to => 0

  include NodeventGlobal

  before_create :check_greater
  after_create :update_current_bid

  def check_greater
    if lot.current_bid and amount <= lot.current_bid.amount
      errors.add(:value, 'is not greater than the current bid')
      return false
    else
      return true
    end
  end

  def update_current_bid
    lot.current_bid = self
    lot.save
    return true
  end

end
