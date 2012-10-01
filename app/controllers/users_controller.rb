class UsersController < ApplicationController

  skip_before_filter :require_user

  before_filter :require_no_user, :only => [:new, :create, :activate]


  def new
    @user = User.new(params[:user])
    @user.time_zone = session[:timezone] || 'UTC'
    captcha = Captcha.random_select
    @question = captcha[:q]
    session[:answer] = captcha[:a]
  end

  def create
    @user = User.new(params[:user])

    # CAPTCHA CHECK OFF
    #if params[:answer].blank? or params[:answer].to_i != session[:answer]
    #  Rails.logger.info("CAPTCHA failed")
    #  flash.now[:notice_sticky] = "Please check your answer to the question"
    #  captcha = Captcha.random_select
    #  @question = captcha[:q]
    #  session[:answer] = captcha[:a]
    #  render :action => :new
    #  return
    #else
    #  session.delete(:answer)
    #end
    session.delete(:answer)


    if @user.save_without_session_maintenance
      @user.send_activate_instructions!
      respond_to do |format|
        format.html {
          redirect_to login_url
          reset_session
          flash[:notice_sticky] = "Thanks for signing up! An email has been sent to: <b><tt>#{@user.email.html_safe}</tt></b><br/><br/>
              <b>Account activation is now required.</b><br/>
              Please check your email (including spam folder) for an account activation link.".html_safe
          if Rails.env.development? && @user.email != "demo@example.com"
            flash[:notice_sticky] += "<br/><br/>Rails development mode: <br/> the activation url you ned to follow is..<br/><br/>#{activate_url(@user.perishable_token).html_safe}<br/>".html_safe
          end
        }
        format.json { render json: @user, status: :created, location: @user }
      end
      #Activity.create!(:request_path => request_path,
      #                 :callback_name => action_name,
      #                 :record_json => @user.to_json,
      #                 :current_user_id => @user.id,
      #                 :what =>  "(#{@user.name}) signed up for a new account")
    else
      captcha = Captcha.random_select
      @question = captcha[:q]
      session[:answer] = captcha[:a]
      respond_to do |format|
        format.html { render :action => :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def confirm_email
    @user = User.find_using_perishable_token(params[:id])

    if @user && @user.active? && @user.old_email? && @user.confirm_email!
      flash[:notice] = "Email Address Confirmed! Thankyou."
      if current_user
        redirect_to home_url
      else
        redirect_to login_url('user_session[email]' => @user.email)
      end
    elsif @user && !@user.active?
      flash[:notice_sticky] = "Please activate account first!"
      redirect_to login_url('user_session[email]' => @user.email)
    elsif @user && @user.old_email.blank?
      flash[:notice_sticky] = "Email Address is not new!"
      redirect_to root_url
    else
      flash[:notice_sticky] = "Confirmation code not found! Please double check!"
      redirect_to login_url
    end
  end

  def resend_activation
    if params[:email]
      @user = User.find_by_email params[:email]
      if @user && !@user.active?
        @user.send_activate_instructions
        flash[:notice_sticky] = "Please check your e-mail (including spam folder) for your account activation instructions!"
        redirect_to root_path
      end
    end
  end


  def activate
    @user = User.find_using_perishable_token(params[:id], 2.weeks)

    if @user && @user.active?
      flash[:notice] = "Account Active! Please login"
    elsif @user && @user.activate!
      flash[:notice] = "Account Activated! Please go back to the app and login"
    else
      flash[:notice] = "Activation code has expired or not found! Please double check! Unactivated accounts are deleted after 24 hours."
    end
    redirect_to root_url
  end

  def resend_activation
    if params[:login]
      @user = User.find_by_login params[:login]
      if @user && !@user.active?
        @user.send_activate_instructions
        flash[:notice] = "Please check your e-mail (including spam folder) for your account activation instructions!"
        redirect_to root_path
      end
    end
  end

  def destroy
    unless @user = User.find(params[:id]) 
      flash[:notice] = "Sorry, User not found.".html_safe
      redirect_back_or_default('/')
      return
    end

    unless  @user == current_user 
      flash[:notice] = "Sorry, User not deleted.".html_safe
      redirect_back_or_default('/')
      return
    end

    @user.destroy
    reset_session
    flash[:notice] = "User #{@user.login} has been deleted".html_safe
    redirect_to '/'
    return
  end

end
