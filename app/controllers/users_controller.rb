class UsersController < ApplicationController
  #TODO
  # Self-signed key will generate warnings
  #force_ssl unless Rails.env.test?
  before_filter(:only => [:index]) { |c| c.require_permission :editor }
  before_filter(:only => [:edit, :update, :crop, :crop_edit]) { |c| c.require_permission :normal_user }

  def index
    @users = User.page(params[:page]).per(ITEMS_PER_PAGE_FEW)
  end

  def masters
    #TODO
    @masters = User.enabled.masters.sort_by{|master| -1 * master.score}
    @stars = @masters.reject{|m| m.avatar.blank?}[0..4]
    @hard_workers = User.desc(:reviews_count).limit(7)
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def show
    @user = User.find(params[:id])

    @modes = ["feeds", "reviews", "albums", "recipes"]
    if params[:mode].present?
      @current_mode = params[:mode]
    elsif session[:user_mode].present?
      @current_mode = session[:user_mode]
    else
       @current_mode = "feeds"
    end
    session[:user_mode] = @current_mode

    page = params[:page].present? ? params[:page].to_i : 0
    @feeds = FeedsManager.get_feeds_of(@user)
    @reviews = @user.reviews.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @albums = @user.albums.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @recipes = @user.recipes.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
  end

  # POST /users
  # POST /users.xml
  def create
    ip = request.remote_ip.to_s
    if Cooler.crazy_register?(ip)
      redirect_to root_path, :notice => t("notices.rapid_user_creation", cooldown: REGISTRATION_COOLDOWM_INTERVAL)
      return
    end

    @user = User.new(params[:user])
    @user.remote_ip = ip

    respond_to do |format|
      if @user.save
        #sign in
        cookies[:auth_token] = @user.auth_token

        format.html { redirect_to "/me" }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if current_user.update_attributes(params[:user])
        format.html { redirect_to(root_path, :notice => t("notices.user_basic_info_updated")) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @current.errors, :status => :unprocessable_entity }
      end
    end
  end

  def verify_email
    @user = User.first(:conditions => {:email_verification_token => params[:id]})
    @user.verify_email!

    redirect_to root_path, :notice => t("notices.email_verified")
  end


  #for validation
  def validates_email
    respond_to do |format|
      format.json { render :json => User.is_email_available?(params[:user][:email]) }
    end
  end

  def validates_login_name
    respond_to do |format|
      format.json { render :json => User.is_login_name_available?(params[:user][:login_name]) }
    end
  end

  def crop

  end

  def crop_update
    current_user.crop_x = params[:avatar]["crop_x"]
    current_user.crop_y = params[:avatar]["crop_y"]
    current_user.crop_h = params[:avatar]["crop_h"]
    current_user.crop_w = params[:avatar]["crop_w"]
    current_user.save
    redirect_to current_user.profile
  end

end
