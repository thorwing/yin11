class TipsController < ApplicationController
  include TipsHelper
  before_filter(:except => [:index, :show, :search]) { |c| c.require_permission :normal_user }
  TIPS_SEARCH_LIMIT = 5

  # GET /tips
  # GET /tips.xml
  def index
    @tips_participated_by_me = current_user ? Tip.any_in(:writer_ids => [current_user.id]) : []
    @hot_tips = Tip.order_by([:votes, :desc]).limit(5)
    @recent_tips = Tip.order_by([:updated_at, :desc]).limit(5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
      format.json { render :json => Tip.all.map { |t| {:id => t.id, :name => t.title} } }
    end
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
    @tip.revise(current_user) if @tip.valid?

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

  def search
    @results = []
    query = params[:search].strip
    if query.present?
      @exact_match = Tip.first(:conditions => {:title => query})
      tag_names = query.split

      if tag_names.size <= 1
        @results = Tip.where(:title => /#{query}?}/)
      else
        exact_results = nil
        tag_names.each do |tag_name|
          exact_results = exact_results ? exact_results.any_in(:tag_ids => [tag_name]) : Tip.any_in(:tag_ids => [tag_name])
        end

        @results = exact_results.order_by([:updated_at, :desc]) if exact_results

        if exact_results.size < TIPS_SEARCH_LIMIT
          @results = @results | Tip.any_in(:tag_ids => tag_names)
        end
      end
    else
      redirect_to :back, :notice => "please enter search string"
      return
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
