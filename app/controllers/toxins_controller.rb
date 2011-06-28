class ToxinsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :user }
  before_filter(:only => [:destroy, :edit, :update, :new, :create]) {|c| c.require_permission :admin }

   # GET /toxins
  # GET /toxins.xml
  def index
    @user = current_user

    if params[:q]
      @toxins = Toxin.where(:name => /#{params[:q]}?/)
    else
      @toxins = Toxin.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @toxins }
      format.json { render :json => @toxins.map { |f| {:id => f.id, :name => f.name } } }
    end
  end

  # GET /toxins/1
  # GET /toxins/1.xml
  def show
    @toxin = Toxin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @toxin }
    end
  end

  # GET /toxins/new
  # GET /toxins/new.xml
  def new
    @toxin = Toxin.new

    respond_to do |format|
      if params[:popup]
        format.html {render "remote_new", :layout => "dialog" }
      else
        format.html # new.html.erb
      end
      format.xml  { render :xml => @toxin }
    end
  end

  # GET /toxins/1/edit
  def edit
    @toxin = Toxin.find(params[:id])
  end

  # POST /toxins
  # POST /toxins.xml
  def create
    @toxin = Toxin.new(params[:toxin])

    respond_to do |format|
      if @toxin.save
        format.html { redirect_to(@toxin, :notice => 'Toxin was successfully created.') }
        format.xml  { render :xml => @toxin, :status => :created, :location => @toxin }
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @toxin.errors, :status => :unprocessable_entity }
        format.js {render :content_type => 'text/javascript'}
      end
    end

  end

  # PUT /toxins/1
  # PUT /toxins/1.xml
  def update
    @toxin = Toxin.find(params[:id])

    respond_to do |format|
      if @toxin.update_attributes(params[:toxin])
        format.html { redirect_to(@toxin, :notice => 'Toxin was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @toxin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /toxins/1
  # DELETE /toxins/1.xml
  def destroy
    @toxin = Toxin.find(params[:id])
    @toxin.destroy

    respond_to do |format|
      format.html { redirect_to(toxins_url) }
      format.xml  { head :ok }
    end
  end

end
