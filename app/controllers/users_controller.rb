class UsersController < ApplicationController
  before_filter(:only => [:block, :unlock]) { |c| c.require_permission :normal_user }

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

    respond_to do |format|
      if @user.save
        format.html { redirect_to([:admin, @user], :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
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

end
