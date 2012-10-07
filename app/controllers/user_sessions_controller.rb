class UserSessionsController < ApplicationController

  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [ :destroy, :switch ]
  skip_before_filter :verify_authenticity_token, :only => [:create]

  
  def new
    if params[:return_to] 
      session[:return_to] = params[:return_to]
    end
    @user_session = UserSession.new({:remember_me => true}.merge(params[:user_session] || {}))
  end
  
  def create
    if params[:user_session] && params[:user_session][:login]
      params[:user_session][:login].strip!
    end
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if @user_session.user.is_admin?
        session[:admin_id] = @user_session.user.id
      end
      session.delete(:timezone)
      respond_to do |format|
        format.html {
          flash[:notice] = "Login successful!"
          if @user_session.user.login_count < 2
            session[:first_login] = true
          end
          if session[:return_to]
            redirect_to session[:return_to]
            session.delete(:return_to)
          else
            redirect_to home_url
          end
        }
        format.json { render :json => {:success => true, :token => form_authenticity_token } }
      end
    else
      if @user_session.attempted_record && !@user_session.invalid_password? && !@user_session.attempted_record.active?
        json_message = "Account not yet activated, please check your email"
        flash[:notice_sticky] = render_to_string(:partial => 'user_sessions/not_active.erb', :locals => { :user => @user_session.attempted_record }).html_safe

      end
      respond_to do |format|
        format.html { render :action => "new" }
        format.json { render :json => {:success => false, :message => json_message || 'incorrect username or password'}, :status => :unauthorized }
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    respond_to do |format|
      format.html {
        reset_session
        flash[:notice] = "Logout successful!"
        redirect_to root_url
      }
      format.json { render :json => {:success => true} }
    end
  end

  # omniauth
  def callback
    if env['omniauth.auth']
      user = User.from_omniauth(env['omniauth.auth'])
      UserSession.create(user)
      
      if user.is_admin?
        session[:admin_id] = @user_session.user.id
      end
      respond_to do |format|
        format.html {
          flash[:notice] = "Login successful!"
          if user.login_count < 2
            session[:first_login] = true
          end
          if session[:return_to]
            redirect_to session[:return_to]
            session.delete(:return_to)
          else
            redirect_to home_url
          end
        }
        format.json { render :json => {:success => true, :token => form_authenticity_token } }
      end
    else
      redirect_to :root_url, :notice => 'Auth info not found'
    end
  end


  # omniauth
  def failure
    flash[:notice] = "Sorry, You din't authorize"
    redirect_to root_url
  end

  def switch
    unless current_user and session[:admin_id]
      reset_session
      flash[:notice] = "Access Denied"
      redirect_to '/'
      return
    end
    if user = User.find(params[:id])
      UserSession.create(user)
      flash[:notice] = "Session Switched! You are now logged in as <strong>#{user.name}</strong>".html_safe
      redirect_to root_url
      return
    else
      @users = User.page(params[:page]).order(params[:order] || 'last_request_at DESC')
    end
  end
end
