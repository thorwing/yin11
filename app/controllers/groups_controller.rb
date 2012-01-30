class GroupsController < ApplicationController
  before_filter(:only => [:join, :quit]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:new, :update, :edit, :create]) { |c| c.require_permission :administrator }

  def index
    #TODO
    #display join and quit links
    if current_user
      @groups = current_user.groups
    else
      @groups = Group.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  def show
    @group = Group.find(params[:id])
    @can_join = (current_user and (not @group.member_ids.include?(current_user.id)))
    @can_quit = (current_user and @group.member_ids.include?(current_user.id))

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])
    @group.creator_id = current_user.id
    #@group.join!(current_user)
    @group.save!

    respond_to do |format|
        format.html { redirect_to(@group, :notice => t("notices.group_created")) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
    end
  end

  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => t("notices.group_updated"))}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def join
    @group = Group.find(params[:id])
    @group.join!(current_user)
    respond_to do |format|
      format.html { redirect_to(@group, :notice => t("notices.group_joind"))}
      format.xml  { head :ok }
    end
  end

  def quit
    @group = Group.find(params[:id])
    @group.quit!(current_user)
    respond_to do |format|
        format.html { redirect_to(@group, :notice => t("notices.group_quited"))}
        format.xml  { head :ok }
    end
  end

end