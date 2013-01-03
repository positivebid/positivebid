class Lot < ActiveRecord::Base
  USER_FIELDS = [
    :number, 
    :name, 
    :buy_now_price, 
    :min_increment, 
    :collected, 
    :timing,
    :sale_start_at,
    :sale_end_at,
    :state_event
  ]
  
  ADMIN_ONLY_FIELDS = [ :paid, :payment_method ]
  ADMIN_FIELDS = USER_FIELDS + ADMIN_ONLY_FIELDS

  attr_accessible *USER_FIELDS
  attr_accessible *ADMIN_FIELDS, :as => :admin

  STATE_DESCRIPTIONS = {
   'draft' => 'Lot is being setup and it\'s listing is not yet visible.',
   'published' => 'Lot listing is now visible.',
   'open' => 'Lot is open for bidding',
   'closing' => 'Lot bidding is closing. Last chance for new bids.',
   'sold' => 'Lot is sold. New bids not acceptted',
   'paid' => 'Lot has been paid for by winning bidder.'
  }

  STATES = STATE_DESCRIPTIONS.keys

  VISIBLE_STATES = %w( published open closing sold paid )
  validates_inclusion_of :state, in: STATES

  TIMINGS = %w( scheduled manual )
  validates_inclusion_of :timing, :in => TIMINGS


  after_initialize :set_defaults

  belongs_to :auction
  has_many :bids, :dependent => :destroy
  belongs_to :current_bid, :class_name => 'Bid'
  has_many :items, :order => 'position ASC', :dependent => :destroy

  after_save :outbid_notify # TODO MAKE ASYNC?


  validates_presence_of :name, :number
  validates_inclusion_of :min_increment, :in => 1..100
  validates_numericality_of :buy_now_price, :greater_than_or_equal_to => 1, :allow_nil => true
  validates_length_of :name, :in => 2..255
  validates_uniqueness_of :number, :scope => :auction_id
  acts_as_list  :scope => :auction
  validate :validate_scheduled_timing

  scope :sorted, :order => 'position ASC'

  scope :draft, where(:state => 'draft')
  scope :published, where(:state => 'published')
  scope :open, where(:state => 'open')
  scope :closing, where(:state => 'closing')
  scope :sold, where(:state => 'sold')
  scope :paid, where(:state => 'paid')
  scope :visible, where(:state => VISIBLE_STATES )

  include NodeventGlobal

  def validate_scheduled_timing
    if timing == "scheduled"
      if sale_start_at.blank?
        errors.add(:sale_start_at, "start time required")
      end
      if sale_end_at.blank?
        errors.add(:sale_end_at, "start time required")
      end
      if sale_start_at.present? and sale_end_at.present? and sale_end_at < sale_start_at
        errors.add(:sale_end_at, "Sale must end after start")
      end
    end
  end

  def outbid_notify
    if changes["current_bid_id"].present? and (old_id = changes["current_bid_id"][0]).present?
      if old_bid = self.bids.where(:id => old_id).first and old_bid.user_id != current_bid.user_id and (old_user = old_bid.user).present?
        if old_user.outbid_confirmation
          room = NoDevent::Emitter.room(old_user)
          Rails.logger.info("ROOM IS #{room.inspect}")
          NoDevent::Emitter.emit(room, 'message', "Alert: You have been outbid on Lot #{id} #{name} by #{current_bid.user.name}" )
        end
      end
    end
  end


  def set_defaults
    self.sale_start_at ||= auction.try(:default_sale_start_at)
    self.sale_end_at ||= auction.try(:default_sale_end_at)
  end

  def bidable?
    open? or closing?
  end

  state_machine :initial => :draft do

    before_transition :draft => :published, :do => :validate_has_an_item

    event :organiser_publish_listing, :admin_publish_listing do
      transition :draft => :published
    end

    event :auto_open, :organiser_open_bidding_now, :admin_open_bidding_now do
      transition :published => :open
    end

    event :auto_close_start, :organiser_start_auto_closing_now, :admin_start_auto_closing_now do
      transition :open => :closing
    end

    event :organiser_close_bidding_immediately, :admin_close_bidding_immediately do
      transition :closing => :sold
      transition :open => :sold
    end

    event :auto_close_done do
      transition :closing => :sold
    end
    before_transition any => :sold do |lot, transition|
      lot.sold_at = Time.now
    end


    event :payment do
      transition :sold => :paid
    end

    event :organiser_mark_payment_recieved, :admin_payment do
      transition :sold => :paid
    end

    before_transition any => :paid do |lot, transition|
      lot.paid_at = Time.now
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

  def validate_has_an_item
    if self.items.blank?
      self.errors.add(:base, "A Lot needs at least 1 item added before being published")
      return true
    else
      return true
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
    Lot.published.where("sale_start_at < ?", Time.now).find_each do |lot|
      lot.auto_open
    end
    Lot.open.where("sale_end_at < ?", Time.now).find_each do |lot|
      lot.auto_close_start
    end
    Lot.closing.where("updated_at < ?", Time.now - 55.seconds).find_each do |lot|
      lot.auto_close_done
    end
  end


end
