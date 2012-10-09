class ApplicationController < ActionController::Base
  protect_from_forgery


  helper_method :current_user_session, :current_user

  if !(Rails.env.production? or Rails.env.development?)
    http_basic_authenticate_with :name => "positive", :password => "bid", :realm => 'PostiveBid access.'
  end

  # Image sizes are excluded (they are consider public and 
  # are accessed using asset_host where session cookie isn't set)
  before_filter :require_user, :except => [:xs, :s, :m, :l, :xl, :xxl, :o, :p20, :p40, :p80, :p160, :p200, :p320, :p400, :p640 ]



  map_enclosing_resource :home, :singleton => true, :class => User, :find => :current_user


  before_filter :set_user_time_zone
  before_filter :set_r_var

  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user || request.path =~ %r|^/public/| 
      respond_to do |format|
      format.html do
        flash[:notice] = "You must be logged in to access that page"
        redirect_to login_url # TODO add support .js and .json requests.
      end
      format.json do
        render :json => {'errors' => "You must be logged in to access this endpoint"}, :status => 403
      end
      end
    return false
    end
  end

  def require_no_user
    if current_user
      respond_to do |format|
        format.html do
          flash[:notice] = "You must be logged out to access that page"
          redirect_to root_url
        end
        format.json do
          render :json => {'errors' => "You must be logged in to access this endpoint"}, :status => 403
        end
      end
      return false
    end
  end

  def require_admin
    unless current_user and session[:admin_id]
      redirect_to root_path, :notice => "You must be an admin to access that page" 
    end
  end

  def set_r_var
    @r = {} # converted to_json as "R" in application layout
    @r['current_user'] = current_user if current_user
    if Rails.env.production?
      @r['app_host']   = 'http://www.positivebid.com'
      @r['asset_host'] = 'http://assets.positivebid.com'
    else
      @r['app_host']   = root_url.sub(/\/$/, "")
      @r['asset_host'] = @r['app_host']
    end
  end

end
