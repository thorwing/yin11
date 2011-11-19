class ReviewsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}

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
    if params[:product_i]
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
    @review.product_id = params[:product_id]
    @review.author = current_user

    ImagesHelper.process_uploaded_images(@review, params[:images])

    #RewardManager.new(current_user).contribute(:posted_reviews)

    @feed = FeedsManager.push_feeds(@review)

    @remote_status = false
    @user_message = ''

    #syncs the review to 3rd party site, e.g. SIna Weibo, Renren...
    if params[:sync_to]
      @user_message, @remote_status = SyncsManager.new(current_user).sync(@review)
    end

    respond_to do |format|
      if @review.save
        @local_status = true
        @user_message = t("notices.review_posted") + @user_message
        format.html { redirect_to(@review, :notice => @user_message) }
        format.xml  { render :xml => @review, :status => :created, :location => @review }
        format.js
      else
        @local_status = false
        @user_message = t("notices.review_post_failure") + @user_message
        format.html { render :action => "new", :notice => @user_message }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
        format.js
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
