class Mailer < ActionMailer::Base

  default :from => 'PositiveBid <jason@positivebid.com>'

  helper :email

  def welcome_user(user)
    @user = user
    headers['X-PositiveBid-Priority'] = '4'
    headers['X-PositiveBid-Category'] = 'welcome_user'
    mail :subject => "[PositiveBid Welcome#{envstring}] PositiveBid welcomes #{user.name}!", :to => user.email, :cc => 'PositiveBid <info@positivebid.com>'

  end



  private 

  def envstring
    Rails.env.production? ? "" : " [#{Rails.env}]"
  end

end
