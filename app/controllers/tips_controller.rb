class TipsController < ApplicationController
  before_filter(:except => [:index, :show, :search]) { |c| c.require_permission :user }
  before_filter(:only => [:destroy]) {|c| c.require_permission :admin }
  TIPS_SEARCH_LIMIT = 5

  # GET /tips
  # GET /tips.xml
  def index
    @tips = Tip.all

    @tips_participated_by_me = current_user ? Tip.any_in(participator_ids: [current_user.id]) : []
    @hot_tips = Tip.order_by([:votes, :desc]).limit(5)
    @recent_tips = Tip.order_by([:updated_at, :desc]).limit(5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
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
    unless params[:type] && params[:title]
      redirect_to :back, :notice => "Invalid parameters for Tip."
      return
    end

    @tip = Tip.new(:title => params[:title])
    @tip.type = params[:type].to_i

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
    @tip.type = params["tip"]["type"].to_i
    @tip.revise(current_user, params[:content])

    respond_to do |format|
      if @tip.save
        format.html { redirect_to(@tip, :notice => 'Tip was successfully created.') }
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
    #@tip.type = params["tip"]["type"].to_i
    @tip.revise(current_user, params[:content])

    respond_to do |format|
      if @tip.save
        format.html { redirect_to(@tip, :notice => 'Tip was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tips/1
  # DELETE /tips/1.xml
  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    respond_to do |format|
      format.html { redirect_to(tips_url) }
      format.xml  { head :ok }
    end
  end

  def search
    @results = []
    query = params[:search].strip
    if query.present?
      @exact_match = Tip.first(conditions: {title: query})
      tag_names = query.split

      if tag_names.size <= 1
        @results = Tip.where(:title => /#{query}?}/)
      else
        exact_results = nil
        tag_names.each do |tag_name|
          exact_results = exact_results ? exact_results.any_in(tag_ids: [tag_name]) : Tip.any_in(tag_ids: [tag_name])
        end

        @results = exact_results.order_by([:updated_at, :desc]) if exact_results

        if exact_results.size < TIPS_SEARCH_LIMIT
          @results = @results | Tip.any_in(tag_ids: tag_names)
        end
      end
    else
      redirect_to :back, :notice => "please enter search string"
      return
    end
  end

  def vote
    @tip = Tip.find(params[:id])
    delta = params[:delta].to_i

    if delta > 0
      if @tip.fan_ids.include?(current_user.id)
        delta *= -1
        @tip.fan_ids.delete(current_user.id)
      elsif @tip.hater_ids.include?(current_user.id)
        @tip.hater_ids.delete(current_user.id)
      else
        @tip.fan_ids << current_user.id
      end
    else
      if @tip.hater_ids.include?(current_user.id)
        delta *= -1
        @tip.hater_ids.delete(current_user.id)
      elsif @tip.fan_ids.include?(current_user.id)
        @tip.fan_ids.delete(current_user.id)
      else
        @tip.hater_ids << current_user.id
      end
    end

    weight = delta * get_vote_weight_of_current_user
    @tip.votes += weight

    respond_to do |format|
      if @tip.save
        format.html {redirect_to tips_path}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { redirect_to @tip }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end
  end

end
