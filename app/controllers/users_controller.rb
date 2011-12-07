class UsersController < ApplicationController
  #TODO
  # Self-signed key will generate warnings
  #force_ssl unless Rails.env.test?
  before_filter(:only => [:edit, :update, :show]) { |c| c.require_permission :normal_user }

  def index
    @masters = User.enabled.masters
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
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    if IncomingRequest.is_rapid_creation?(request.remote_ip.to_s)
      redirect_to root_path, :notice => t("notices.rapid_user_creation")
      return
    end

    respond_to do |format|
      if @user.save
        IncomingRequest.record_creation(request.remote_ip.to_s)
        #TODO wrap in a method?
        cookies[:auth_token] = @user.auth_token

        format.html { redirect_to edit_profile_path(current_user.profile) }
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
  def check_email
    respond_to do |format|
      format.json { render :json => User.is_email_available?(params[:user][:email]) }
    end
  end

end
