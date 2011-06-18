class RecommendationsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :user }
  before_filter(:only => [:edit, :update, :destroy]) {|c| c.the_author_himself(Recommendation.name, c.params[:id], true)}
  uses_tiny_mce :only => [:new, :edit], :options => get_tiny_mce_style
  layout :resolve_layout

  # GET /recommendations
  # GET /recommendations.xml
  def index
    @recommendations = Recommendation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recommendations }
    end
  end

  # GET /recommendations/1
  # GET /recommendations/1.xml
  def show
    @recommendation = Recommendation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recommendation }
    end
  end

  # GET /recommendations/new
  # GET /recommendations/new.xml
  def new
    @recommendation = Recommendation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recommendation }
    end
  end

  # GET /recommendations/1/edit
  def edit
    @recommendation = Recommendation.find(params[:id])
  end

  # POST /recommendations
  # POST /recommendations.xml
  def create
    @recommendation = Recommendation.new(params[:recommendation])

    respond_to do |format|
      if @recommendation.save
        format.html { redirect_to(@recommendation, :notice => 'Recommendation was successfully created.') }
        format.xml  { render :xml => @recommendation, :status => :created, :location => @recommendation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recommendation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recommendations/1
  # PUT /recommendations/1.xml
  def update
    @recommendation = Recommendation.find(params[:id])

    respond_to do |format|
      if @recommendation.update_attributes(params[:recommendation])
        format.html { redirect_to(@recommendation, :notice => 'Recommendation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recommendation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.xml
  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_to(recommendations_url) }
      format.xml  { head :ok }
    end
  end

  private
  def resolve_layout
    case action_name
      when 'show'
        "map"
      else
        "application"
    end
  end
end
