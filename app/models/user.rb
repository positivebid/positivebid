class User < ActiveRecord::Base
  USER_FIELDS  = [ 
    :email, 
    :first_name, 
    :last_name, 
    :mobile_number, 
    :telephone_number, 
    :outbid_confirmation, 
    :share_confirmation, 
    :bid_confirmation,  
    :anonymous_bidder, 
    :time_zone, 
    :password, 
    :password_confirmation ]

  ADMIN_ONLY_FIELDS =  [ :positive_admin ]
  ADMIN_FIELDS = USER_FIELDS + ADMIN_ONLY_FIELDS

  attr_accessible *USER_FIELDS
  attr_accessible *ADMIN_FIELDS, :as => :admin

  before_validation :strip_attributes
  validates_presence_of :first_name, :last_name, :time_zone
  validates_length_of :first_name, :in => 2..40
  validates_length_of :last_name, :in => 2..40


  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt

    c.ignore_blank_passwords = true #ignoring passwords for omniauth
    c.validate_password_field = false #ignoring validations for password fields

    c.merge_validates_length_of_password_field_options( { minimum: 8 } )
    c.merge_validates_uniqueness_of_email_field_options({ :allow_nil => true })
    c.merge_validates_format_of_email_field_options({ :allow_nil => true} )
    c.perishable_token_valid_for =  2.days # allow time for password reset
  end


  def name
    "#{first_name} #{last_name}"
  end

  def send_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end

  def send_activate_instructions!
    reset_perishable_token!
    Notifier.activate_instructions(self).deliver
  end

  def send_activate_instructions
    Notifier.activate_instructions(self).deliver
  end

  def activate!
    reset_perishable_token!
    self.activated_at = Time.now
    self.active = true
    save
    Mailer.welcome_user(self).deliver
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end

  def strip_attributes
    write_attribute(:first_name, first_name.strip) if first_name.present?
    write_attribute(:last_name, last_name.strip) if last_name.present?
    write_attribute(:email, email.strip) if email.present?
  end

  def is_admin?
    positive_admin
  end

  ########################## omniauth stuff #############
 
  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    user = new do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = auth["info"]["email"]
      user.image_url = auth["info"]["image"]
      if auth["info"]["first_name"].present? and auth["info"]["last_name"].present?
        user.first_name = auth["info"]["first_name"]
        user.last_name = auth["info"]["last_name"]
      else
        nameparts = auth["info"]["name"].split(/\s+/)
        if nameparts.length > 1
          user.first_name = nameparts.shift
          user.last_name = nameparts.join(" ")
        else
          user.first_name = auth["info"]["name"]
          user.last_name = auth["info"]["name"]
        end
      end
      user.activated_at = Time.now
      user.active = true
    end
    user.save!
    user.reset_persistence_token!
    user
  end
  


  ########################## app stuff #############
  has_many :auctions, :dependent => :nullify
  has_many :bids, :dependent => :nullify

  include NodeventGlobal


end
