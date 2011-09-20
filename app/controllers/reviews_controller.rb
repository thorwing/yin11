class ReviewsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}
  #uses_tiny_mce :only => [:new, :edit], :options => get_tiny_mce_style

  # GET /reviews
  # GET /reviews.xml
  def index
    @reviews = Review.desc(:reported_on, :votes).page(params[:page]).per(20)

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
    if params[:vendor_id]
      vendor = Vendor.find(params[:vendor_id])
      @review = vendor.reviews.build
    else
      @review = Review.new
    end

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

    if params[:images]
      params[:images][0..4].each do |image_id|
        image = Image.find(image_id)
        image.info_item_id = @review.id
        image.save
        #@review.image_ids << image_id
      end
    end

    RewardManager.new(current_user).contribute(:posted_reviews)

    if params[:sync_to_sina]
      SyncsManager.new(current_user).sync(@review)
    end

    respond_to do |format|
      if @review.save
        format.html { redirect_to(@review, :notice => t("notices.review_posted")) }
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

    @review.images.each do |image|
      image.delete unless params[:images][0..4].include? image.id.to_s
    end

    if params[:images]
      params[:images][0..4].each do |image_id|
        image = Image.find(image_id)
        if image.info_item_id.blank?
          image.info_item_id = @review.id
          image.save
        end
      end
    end

    respond_to do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to(@review, :notice => t("notices.review_updated")) }
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
