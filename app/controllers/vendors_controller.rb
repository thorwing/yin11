class VendorsController < ApplicationController
  before_filter(:only => [:new, :create]) { |c| c.require_permission :user }
  #before_filter(:only => [:edit, :update, :destroy]) {|c| c.the_author_himself(Vendor.name, c.params[:id], true)}
  layout :resolve_layout

  # GET /vendors
  # GET /vendors.xml
  def index
    @vendors = params[:q] ? Vendor.where(:name => /#{params[:q]}?/) : Vendor.all

    logger = Logger.new(STDOUT)
    logger.info ">>> parameters:" + params[:q] if params[:q]

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
    @vendor = Vendor.new
    @vendor.build_address
    respond_to do |format|
      if params[:popup]
        format.html {render "remote_new", :layout => "dialog" }
      else
        format.html # new.html.erb
      end
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/1/edit
  def edit
    @vendor = Vendor.find(params[:id])
    if @vendor.disabled and not has_permission?(:editor)
      redirect_to vendors_path
      return
    end
  end

  # POST /vendors
  # POST /vendors.xml
  def create
    @vendor = Vendor.new(params[:vendor])

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to(@vendor, :notice => 'Vendor was successfully created.') }
        format.xml  { render :xml => @vendor, :status => :created, :location => @vendor }
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
        format.js {render :content_type => 'text/javascript'}
      end
    end
  end

  # PUT /vendors/1
  # PUT /vendors/1.xml
  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to(@vendor, :notice => 'Vendor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.xml
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to(vendors_url) }
      format.xml  { head :ok }
    end
  end

  def search
    @results = []
    query = params[:search].strip
    if query.present?
      @exact_match = Vendor.first(conditions: {name: query})
      tag_names = query.split

      if tag_names.size <= 1
        @results = Vendor.where(:name => /#{query}?}/)
      else
        exact_results = nil
        tag_names.each do |tag_name|
          exact_results = exact_results ? exact_results.any_in(tag_ids: [tag_name]) : Vendor.any_in(tag_ids: [tag_name])
        end

        @results = exact_results.order_by([:updated_at, :desc]) if exact_results

        @results = @results | Tip.any_in(tag_ids: tag_names)

      end
    else
      redirect_to :back, :notice => "please enter search string"
      return
    end
  end

  private
  def resolve_layout
    case action_name
      when 'new', 'edit', 'show'
        "map"
      else
        'application'
    end
  end

end
