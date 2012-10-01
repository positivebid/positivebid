class User < ActiveRecord::Base
  attr_accessible :anonymous_bidder, :bid_confirmation,  :email, :first_name, :last_name, :mobile_number, :outbid_confirmation, :share_confirmation, :telephone_number, :time_zone, :password, :password_confirmation

  before_validation :strip_attributes
  validates_presence_of :first_name, :last_name, :time_zone
  validates_length_of :first_name, :in => 2..40
  validates_length_of :last_name, :in => 2..40


  acts_as_authentic do |c|
    c.transition_from_crypto_providers = [Authlogic::CryptoProviders::Sha512]
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt

    c.merge_validates_length_of_password_field_options( { minimum: 8 } )
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


  ########################## app stuff #############
  has_many :auctions, :dependent => :nullify


end
