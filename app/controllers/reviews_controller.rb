class ReviewsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :user }
  before_filter(:only => [:destroy]) {|c| c.require_permission :admin }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}

  # GET /reviews
  # GET /reviews.xml
  def index
    @my_reviews = Review.where(author_id: current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.xml
  def new
    @review = Review.new

#    1.times do
#      @review.checkpoints.build(:title => "sample")
#    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.xml
  def create
    @review = Review.new(params[:review])
    @review.author = current_user

    respond_to do |format|
      if @review.save
        format.html { redirect_to(reviews_path, :notice => 'Review was successfully created.') }
        format.xml  { render :xml => @review, :status => :created, :location => @review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.xml
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to(reviews_path, :notice => 'Review was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.xml
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to(reviews_url) }
      format.xml  { head :ok }
    end
  end

  def vote
    @review = Review.find(params[:id])
    delta = params[:delta].to_i

    if delta > 0
      if @review.fan_ids.include?(current_user.id)
        delta *= -1
        @review.fan_ids.delete(current_user.id)
      elsif @review.hater_ids.include?(current_user.id)
        @review.hater_ids.delete(current_user.id)
      else
        @review.fan_ids << current_user.id
      end
    else
      if @review.hater_ids.include?(current_user.id)
        delta *= -1
        @review.hater_ids.delete(current_user.id)
      elsif @review.fan_ids.include?(current_user.id)
        @review.fan_ids.delete(current_user.id)
      else
        @review.hater_ids << current_user.id
      end
    end

    weight = delta * get_vote_weight_of_current_user
    @review.votes += weight

    respond_to do |format|
      if @review.save
        format.html {redirect_to root_path}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { redirect_to @review }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end

  end

  protected
  def get_vote_weight_of_current_user
    weight = 0

    if current_user
      if current_user.is_admin?
        weight = 5
      elsif current_user.is_editor?
        weight = 3
      else
        weight = 1
      end
    end
    weight
  end
end
