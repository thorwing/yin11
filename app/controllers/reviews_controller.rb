class ReviewsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :user }
  before_filter(:only => [:edit, :update, :destroy]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}

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
    current_user.contribution.created_reviews += 1
    current_user.save

    #TODO
    Badge.enabled.each do |badge|
      if badge.can_be_awarded_to?(current_user)
        badge.give_to_user_and_save(current_user)
      end
    end

    respond_to do |format|
      if @review.save
        format.html { redirect_to(@review, :notice => 'Review was successfully created.') }
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
        format.html { redirect_to(@review, :notice => 'Review was successfully updated.') }
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
end
