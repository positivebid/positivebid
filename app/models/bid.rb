class Bid < ActiveRecord::Base
  attr_accessible :amount, :lot_id

  belongs_to :lot
  belongs_to :user

  validates_presence_of :lot, :user, :amount
  validates_numericality_of :amount, :greater_than_or_equal_to => 0
  validates_uniqueness_of :amount, :scope => :lot_id
  validate :check_greater
  validate :bidding_open


  after_create :emit_create #custom
  after_create :emit_update
  after_create :update_lot_current_bid
  after_destroy :update_lot_current_bid_from_db

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

  def update_lot_current_bid
    lot.current_bid = self
    lot.save
    return true
  end

  def update_lot_current_bid_from_db
    if last_hightest = lot.bids.order('amount DESC').first
      last_hightest.update_lot_current_bid
    end
    return true
  end

  def emit_create
    NoDevent::Emitter.emit('global_room', "users:create", UserSerializer.new(self.user, :root => false).as_json )
    NoDevent::Emitter.emit('global_room', "bids:create", self )
  end

  def emit_update
    NoDevent::Emitter.emit('global_room', "bids:update", self )
  end

  #include NodeventGlobal

end
