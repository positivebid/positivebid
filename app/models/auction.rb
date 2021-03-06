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
    :organiser_name,
    :organiser_email,
    :organiser_telephone,
    :charity_contact_email, 
    :charity_contact_name, 
    :charity_contact_telephone, 
    :charity_name, 
    :charity_approved, 
    :fundraising_target, 
    :manual_payment_accepted,
    :manual_payment_instructions,
    :justgiving_payment_accepted,
    :justgiving_sdi_charity_id,
    :picture_attributes,
    :state_event
  ]

  ADMIN_ONLY_FIELDS = [ :charity_approved ]
  ADMIN_FIELDS = USER_FIELDS + ADMIN_ONLY_FIELDS


  attr_accessible *USER_FIELDS
  attr_accessible *ADMIN_FIELDS, :as => :admin

  has_one :picture, as: :owner, dependent: :destroy, select: Picture::LITE_SELECT
  has_one :full_picture, as: :owner, class_name: 'Picture'
  accepts_nested_attributes_for :picture

  validates_presence_of :name
  validates_presence_of :charity_name
  validates_presence_of :charity_contact_name
  validates_presence_of :charity_contact_email
  validates_presence_of :charity_contact_telephone
  validates_presence_of :organiser_name
  validates_presence_of :organiser_email
  validates_presence_of :organiser_telephone
  validates_length_of :name, :in => 2..100
  validates_length_of :manual_payment_instructions, :maximum => 250, :allow_nil => true
  validates_inclusion_of :default_lot_timing, :in => Lot::TIMINGS
  validate :validate_at_least_one_payment_method
  validate :validate_justgiving_payment
  validate :validate_manual_payment
  validates_format_of :justgiving_sdi_charity_id, :with => /^\d+$/, :allow_blank => true, :message => 'numbers only'


  belongs_to :user  # the requestor 

  has_many :lots, :order => 'position ASC', :dependent => :destroy
  has_many :items, :through => :lots
  has_many :bids, :through => :lots


  def validate_at_least_one_payment_method
    if not manual_payment_accepted and not justgiving_payment_accepted
      errors.add(:base, "must have at least one payment method accepted")
    end
  end

  def validate_justgiving_payment
    if justgiving_payment_accepted and justgiving_sdi_charity_id.blank?
      errors.add(:justgiving_sdi_charity_id, "can not be blank when JustGiving payment is accepted")
    end
  end

  def validate_manual_payment
    if manual_payment_accepted and manual_payment_instructions.blank?
      errors.add(:manual_payment_instructions, "can not be blank when manual payment is accepted")
    end
  end

  include NodeventGlobal  # todo: only for active

  STATE_DESCRIPTIONS = {
    'draft' => 'Auction is being setup by organiser and has not yet been submitted for approval.',
    'submitted' => 'Auction has been submitted for approval to PositiveBid. PositiveBid will check accuracy of auction details before approving Auction',
    'active' => 'Auction has been approved and now listed live on the PositiveBid.com bidding website app for bidders to view and bid on open lots.',
    'archived' => 'The Auction has been archived and removed from the listing on the PositiveBid.com website app.'
    }

  STATES = STATE_DESCRIPTIONS.keys

  validates_inclusion_of :state, in: STATES

  scope :draft, where(:state => 'draft')
  scope :submitted, where(:state => 'submitted')
  scope :active, where(:state => 'active')
  scope :archived, where(:state => 'archived')

  state_machine :initial => :draft do

    event :organiser_submit_for_approval, :admin_submit do 
      transition :draft => :submitted
    end


    event :admin_approve do
      transition :submitted => :active
    end

    event :organiser_archive, :admin_archive do
      transition :active => :archived
    end

    before_transition any => any do |auction, transition|
      auction.append_to_log %|Transitioning from state "#{transition.from}" to state "#{transition.to}" due to event "#{transition.human_event}"|
    end

  end

  def append_to_log(text)
    if self.new_record?
      logger.info("#{Time.now.to_s} Auction New: #{text}\n")
      self.log = (log || '') + "#{Time.now.to_s} #{text}\n"
    else
      logger.info("#{Time.now.to_s} Auction #{id}: #{text}\n")
      self.update_column(:log, (log || '') + "#{Time.now.to_s} #{text}\n")
    end
  end




end
