class FoodsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :user }
  before_filter(:only => [:destroy, :edit, :update, :new, :create]) {|c| c.require_permission :admin }

  # GET /foods
  # GET /foods.xml
  def index
    @user = current_user

    if params[:foods]
      foods_to_search = params[:foods].split()
      @foods = Food.any_in(name: foods_to_search)
    elsif params[:q]
      @foods = Food.where(:name => /#{params[:q]}?/)
      @foods |= Food.any_in(:aliases => [/#{params[:q]}?/])
    else
      @foods = Food.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @foods }
      format.json { render :json => @foods.map { |f| {:id => f.id, :name => f.name } } }
    end
  end

  # GET /foods/1
  # GET /foods/1.xml
  def show
    @food = Food.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @food }
    end
  end

  # GET /foods/new
  # GET /foods/new.xml
  def new
    @food = Food.new

    respond_to do |format|
      if params[:popup]
        format.html {render "remote_new", :layout => "dialog" }
      else
        format.html # new.html.erb
      end
      format.xml  { render :xml => @food }
    end
  end

  # GET /foods/1/edit
  def edit
    @food = Food.find(params[:id])
  end

  # POST /foods
  # POST /foods.xml
  def create
    name = params[:food][:name]
    if Food.any_in(aliases: [name]).all.size > 0
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @food.errors, :status => :unprocessable_entity }
        format.js {render :content_type => 'text/javascript'}
      end
    else
      @food = Food.new(params[:food])

      respond_to do |format|
        if @food.save
          format.html { redirect_to(@food, :notice => 'Food was successfully created.') }
          format.xml  { render :xml => @food, :status => :created, :location => @food }
          format.js {render :content_type => 'text/javascript'}
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @food.errors, :status => :unprocessable_entity }
          format.js {render :content_type => 'text/javascript'}
        end
      end
    end
  end

  # PUT /foods/1
  # PUT /foods/1.xml
  def update
    @food = Food.find(params[:id])

    respond_to do |format|
      if @food.update_attributes(params[:food])
        format.html { redirect_to(@food, :notice => 'Food was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @food.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.xml
  def destroy
    @food = Food.find(params[:id])
    @food.destroy

    respond_to do |format|
      format.html { redirect_to(foods_url) }
      format.xml  { head :ok }
    end
  end

  def watch
    @food = Food.find(params[:id])
    current_user.profile.watching_foods << @food.name unless current_user.profile.watching_foods.include?(@food.name)
    current_user.profile.save

    respond_to do |format|
      format.html { redirect_to root_path }
      format.xml  { head :ok }
    end
  end
end
