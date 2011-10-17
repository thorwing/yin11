class BadgesController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :administrator }

  # GET /badges
  # GET /badges.xml
  def index
    @badges = Badge.enabled.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @badges }
    end
  end

  # GET /badges/1
  # GET /badges/1.xml
  def show
    @badge = Badge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @badge }
    end
  end

  def new
    @badge = Badge.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @badge }
    end
  end

  def edit
    @badge = Badge.find(params[:id])
  end

  def create
    @badge = Badge.new(params[:badge])

    respond_to do |format|
      if @badge.save
        format.html { redirect_to( @badge, :notice => 'Badge was successfully created.') }
        format.xml  { render :xml => @badge, :status => :created, :location => @badge }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @badge = Badge.find(params[:id])

    respond_to do |format|
      if @badge.update_attributes(params[:badge])
        format.html { redirect_to( @badge, :notice => 'Badge was successfully created.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @badge = Badge.find(params[:id])
    @badge.destroy

    respond_to do |format|
      format.html { redirect_to(badges_url) }
      format.xml  { head :ok }
    end
  end

end
