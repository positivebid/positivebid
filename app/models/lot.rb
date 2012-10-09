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

  STATES = %w( draft published withdrawn forsale bought closing sold paid )
  validates_inclusion_of :state, in: STATES

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

  scope :draft, where(:state => 'draft')
  scope :published, where(:state => 'published')
  scope :forsale, where(:state => 'forsale')
  scope :bought, where(:state => 'bought')
  scope :sold, where(:state => 'sold')
  scope :closing, where(:state => 'closing')
  scope :paid, where(:state => 'paid')

  include NodeventGlobal


  state_machine :initial => :draft do

    event :organiser_publish do
      transition :draft => :published
    end

    event :auto_open do
      transition :published => :forsale
    end

    event :auto_close_start do
      transition :forsale => :closing
    end

    event :auto_close_done do
      transition :closing => :sold
    end

    event :buy_now do
      transition :forsale => :bought
    end

    event :payment do
      transition :bought  => :paid
      transition :sold => :paid
    end

    before_transition any => :paid do |lot, transition|
      lot.paid = true
      true # need this
    end

    before_transition any => any do |lot, transition|
      lot.append_to_log %|Transitioning from state "#{transition.from}" to state "#{transition.to}" due to event "#{transition.human_event}"|
    end

  end

  def append_to_log(text)
    if self.new_record?
      logger.info("#{Time.now.to_s} Deal New: #{text}\n")
      self.log = (log || '') + "#{Time.now.to_s} #{text}\n"
    else
      logger.info("#{Time.now.to_s} Deal #{id}: #{text}\n")
      self.update_column(:log, (log || '') + "#{Time.now.to_s} #{text}\n")
    end
  end


  def self.order_by_ids(ids)
    transaction do
      ids.each_index do |i|
        find(ids[i]).update_column(:position, i+1)
      end
    end
  end

  def self.minute_process
    sleep 1 
    Lot.published.where("sale_start_at < ?", Time.now).find_each do |lot|
      lot.auto_open
    end
    Lot.forsale.where("sale_end_at < ?", Time.now).find_each do |lot|
      lot.auto_close_start
    end
    Lot.closing.where("updated_at < ?", Time.now - 1.minute).find_each do |lot|
      lot.auto_close_done
    end
  end


end
