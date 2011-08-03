class TipsController < ApplicationController
  include TipsHelper
  before_filter(:except => [:index, :show, :search]) { |c| c.require_permission :normal_user }
  TIPS_SEARCH_LIMIT = 5

  # GET /tips
  # GET /tips.xml
  def index
    criteria = params[:q].present? ? Tip.where(:title => /#{params[:q]}?/) : Tip.all
    #TODO
    @unsorted_tips = criteria.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
    evaluator = EvaluationManager.new(current_user)
    @tips = evaluator.sort_items_by_score(@unsorted_tips)
  end

  # GET /tips/1
  # GET /tips/1.xml
  def show
    @tip = Tip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  # GET /tips/new
  # GET /tips/new.xml
  def new
    if params[:title].present?
      @tip = Tip.new(:title => params[:title])
    else
      @tip = Tip.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  # GET /tips/1/edit
  def edit
    @tip = Tip.find(params[:id])
  end

  # POST /tips
  # POST /tips.xml
  def create
    @tip = Tip.new(params[:tip])
    @tip.revise(current_user)

    respond_to do |format|
      if @tip.save
        format.html { redirect_to(@tip, :notice => t("notices.tip_created")) }
        format.xml  { render :xml => @tip, :status => :created, :location => @tip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tips/1
  # PUT /tips/1.xml
  def update
    @tip = Tip.find(params[:id])
    @tip.update_attributes(params[:tip])
    @tip.revise(current_user)

    respond_to do |format|
      if @tip.save
        format.html { redirect_to(@tip, :notice => t("notices.tip_updated")) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
      end
    end
  end

  def collect
    @tip = Tip.find(params[:id])
    if is_already_collected(@tip)
      respond_to do |format|
         format.html {redirect_to(@tip, :alert => I18n.t("alerts.tip_already_collected"))}
      end
    else
      current_user.profile.collect_tip!(@tip)
      respond_to do |format|
         format.html {redirect_to(@tip, :notice => I18n.t("notices.tip_collected"))}
      end
    end
  end

  def revisions
    @tip = Tip.find(params[:id])
    @revisions = @tip.revisions.desc(:created_at).all
  end

  def roll_back
    @tip = Tip.find(params[:id])
    @tip.roll_back!(params[:revision_id])

    respond_to do |format|
      format.html {redirect_to(@tip, :notice => I18n.t("notices.tip_roll_backed"))}
    end
  end

end
