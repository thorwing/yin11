class ReviewsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :user }
  before_filter(:only => [:destroy]) {|c| c.require_permission :admin }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}

  # GET /reviews
  # GET /reviews.xml
  def index
    @reviews = Review.all

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
    current_user.posted_reviews += 1
    current_user.save

    #TODO
    Badge.all.each do |badge|
      if badge.can_be_awarded_to?(current_user)
        badge.give_to_user_and_save(current_user)
      end
    end

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

  def new_comment
    @review = Review.find(params[:id])
    if params[:parent_comment_id].present?
      parent_comment = @review.comments.find(params[:parent_comment_id])
      @comment = parent_comment.children.build(:content => params[:content])
    else
      @comment = Comment.new(:content => params[:content])
    end
  end

  def add_comment
    @review = Review.find(params[:id])
    if params[:parent_comment_id].present?
      parent_comment = @review.comments.find(params[:parent_comment_id])
      new_comment = parent_comment.children.build(:content => params[:content], :user_id => current_user.id)
      #parent_comment.children.create(:content => params[:content], :user_id => current_user.id)
      @review.comments << new_comment
    else
      @review.comments ||= []
      @review.comments << Comment.new(:content => params[:content], :user_id => current_user.id)
    end

     respond_to do |format|
        format.html {redirect_to @review}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
    end
  end
end
