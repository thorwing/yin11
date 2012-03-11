class UsersController < ApplicationController
  #TODO
  # Self-signed key will generate warnings
  #force_ssl unless Rails.env.test?
  before_filter(:only => [:index]) { |c| c.require_permission :editor }
  before_filter(:only => [:edit, :update, :crop, :crop_edit, :fans]) { |c| c.require_permission :normal_user }

  def index
    @users = User.page(params[:page]).per(ITEMS_PER_PAGE_FEW)
  end

  def masters
    @masters = User.enabled.masters.sort_by{|master| -1 * master.score}
    #TODO
    @hard_workers = User.desc(:score).limit(20).reject{|u| @masters.include?(u) || u.avatar.blank?}
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

    @modes = ["desires", "recipes", "albums" ]
    if @modes.include? params[:mode]
      @current_mode = params[:mode]
    #elsif @modes.include? session[:user_mode]
    #  @current_mode = session[:user_mode]
    else
       @current_mode = "desires"
    end
    session[:user_mode] = @current_mode

    page = params[:page].present? ? params[:page].to_i : 0
    #@feeds = FeedsManager.get_feeds_of(@user).reject{|f| f.cracked? || f.created_at.blank? || f.author.blank?}.sort{|x, y| y.created_at <=> x.created_at}.take(ITEMS_PER_PAGE_MANY)
    @desires = @user.desires.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @albums = @user.albums.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @recipes = @user.recipes.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
  end

  # POST /users
  # POST /users.xml
  def create

    #TODO invitation
    invitation = nil
    if params[:invitation]
      invitation = Invitation.first(:conditions => {:code => params[:invitation], :used => false})
    end
    if invitation.blank?
      redirect_to :sign_up, :notice => t("authentication.invalid_invitation")
      return
    end

    ip = request.remote_ip.to_s
    if Cooler.crazy_register?(ip)
      redirect_to root_path, :notice => t("notices.rapid_user_creation", cooldown: REGISTRATION_COOLDOWM_INTERVAL)
      return
    end

    @user = User.new(params[:user])
    @user.remote_ip = ip

    respond_to do |format|
      if @user.save

        #TODO invitation
        if invitation
          invitation.used = true
          invitation.invitee = @user.id.to_s
          invitation.save
        end


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

  def edit
    current_user.current_step = params[:step]
  end

  def update
    if params[:user][:old_password].present?
      unless current_user.authenticate(params[:user][:old_password])
        respond_to do |format|
          format.html { redirect_to :back, :notice => t("alerts.old_password_invalid") }
        end
        return
      end
    end

    respond_to do |format|
      if current_user.update_attributes(params[:user])
        format.html { redirect_to(profile_user_path(current_user), :notice => t("notices.user_basic_info_updated")) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @current.errors, :status => :unprocessable_entity }
      end
    end
  end

  #for auto complete in writing messages
  def fans
    query_str = params[:q]
    criteria = User.any_in(_id: current_user.followers)
    if query_str.present?
      criteria = criteria.where(login_name: /#{query_str}/i)
    end

    @fans = criteria.to_a

    respond_to do |format|
      format.json { render :json => @fans.map { |f| {:id => f.id.to_s, :name => f.login_name}} }
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
    redirect_to profile_user_path(current_user)
  end

end
