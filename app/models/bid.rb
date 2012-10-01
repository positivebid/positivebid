class Bid < ActiveRecord::Base
  attr_accessible :amount

  belongs_to :lot
  belongs_to :user

  validates_presence_of :lot, :user
  validates_numericality_of :amount, :greater_than_or_equal_to => 0

end
