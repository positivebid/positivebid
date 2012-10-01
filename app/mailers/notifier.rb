class Notifier < ActionMailer::Base

  default :from  => 'PositiveBid <jason@positivebid.com>'
  helper :email
  
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    @user = user
    headers['X-PositiveBid-Priority'] = '1'
    headers['X-PositiveBid-Category'] = 'password_reset'
    mail :subject => "[PositiveBid#{envstring}] Password Reset Instructions", :to => user.email, :cc => 'jason@positivebid.com'
    
  end
  
  def activate_instructions(user)
    @url = activate_url(user.perishable_token)
    @user = user
    headers['X-PositiveBid-Priority'] = '0'
    headers['X-PositiveBid-Category'] = 'activate_link'
    mail :subject => "[PositiveBid#{envstring}] Account Activation Link for #{@user.first_name}", :to => user.email, :cc => 'jason@positivebid.com'
    
  end

  def confirm_email_instructions(user)
    @url = confirm_email_url(user.perishable_token)
    @user = user
    headers['X-PositiveBid-Priority'] = '1'
    headers['X-PositiveBid-Category'] = 'confirm_email'

    mail :subject => "[PositiveBid#{envstring}] Confirm Email Link", :to => user.email
    
  end


  private 

  def envstring
    Rails.env.production? ? "" : " [#{Rails.env}]"
  end

end
