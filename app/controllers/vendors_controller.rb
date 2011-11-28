class VendorsController < ApplicationController
  #before_filter(:only => [:new, :create, :mine]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:new, :edit, :update, :destroy]) { |c| c.require_permission :editor }
  #before_filter(:only => [:edit, :update, :destroy]) {|c| c.the_author_himself(Vendor.name, c.params[:id], true)}
  layout :resolve_layout

  # GET /vendors
  # GET /vendors.xml
  def index
    criteria = Vendor.enabled#.of_city(current_city.name)
    criteria = criteria.where(:type => params[:type]) if params[:type].present?
    @vendors = criteria.page(params[:page]).per(50)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vendors }
      format.json { render :json => @vendors.map { |f| {:id => f.id, :name => f.name} } }
    end
  end

  # GET /vendors/1
  # GET /vendors/1.xml
  def show
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/new
  # GET /vendors/new.xml
  def new
    @vendor = Vendor.new(:name => (params[:name].present? ? params[:name] : ""))

    respond_to do |format|
      if params[:popup]
        format.html {render "remote_new", :layout => "dialog" }
      else
        format.html # new.html.erb
      end
      format.xml  { render :xml => @vendor }
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  # POST /vendors
  # POST /vendors.xml
  def create
    @vendor = Vendor.new(params[:vendor])
    @vendor.creator = current_user

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to(@vendor, :notice => t("notices.vendor_created")) }
        format.xml  { render :xml => @vendor, :status => :created, :location => @vendor }
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
        format.js {render :content_type => 'text/javascript'}
      end
    end
  end

  def mine
      @my_vendors = Vendor.where(:creator_id => current_user.id)
  end

  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to( @vendor, :notice => 'Vendor was successfully created.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to(vendors_url) }
      format.xml  { head :ok }
    end
  end


  def browse
    criteria = Vendor.enabled.of_city(current_city.name)
    @vendors = criteria.all

    respond_to do |format|
      if params[:popup]
        format.html {render "browse", :layout => "dialog" }
      else
        format.html
      end
    end
  end

  def pick
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  private
  def resolve_layout
    case action_name
      when 'new'
        "map"
      else
        'application'
    end
  end

end
