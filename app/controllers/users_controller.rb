class UsersController < ApplicationController
  before_filter(:only => [:edit, :update, :block, :unlock]) { |c| c.require_permission :normal_user }

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
    saved = @user.save
    @user.send_activation if saved

    respond_to do |format|
      if saved
        format.html { render "activation_required"}
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit

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

  def activate
    @user = User.first(:conditions => {:activation_token => params[:id]})
    @user.activate!

    redirect_to login_url, :notice => t("notices.user_activated")
  end

  def block
    user_id = params[:id]
    unless current_user.id == user_id || (current_user.blocked_user_ids && current_user.blocked_user_ids.include?(user_id))
      current_user.blocked_user_ids ||= []
      current_user.blocked_user_ids << user_id
      current_user.save
    end

    respond_to do |format|
      format.html { redirect_to(:back, :notice => t("notices.user_blocked"))}
      format.xml  { head :ok }
    end
  end

  def unlock
    user_id = params[:id]
    if current_user.blocked_user_ids && current_user.blocked_user_ids.include?(user_id)
      current_user.blocked_user_ids.delete(user_id)
      current_user.save
    end

    respond_to do |format|
      format.html { redirect_to(:back, :notice => t("notices.user_unlocked"))}
      format.xml  { head :ok }
    end
  end

  #for validation
  def check_email
    respond_to do |format|
      format.json { render :json => User.is_email_available?(params[:user][:email]) }
    end
  end

end
