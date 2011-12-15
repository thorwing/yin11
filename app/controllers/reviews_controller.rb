class ReviewsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}

  # GET /reviews
  # GET /reviews.xml
  def index
    @hard_workers = User.desc(:reviews_count)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    #  used for waterfall displaying
    criteria = Review.all
    criteria = criteria.any_in(product_ids: [params[:product_id]]) if params[:product_id].present?
    criteria = criteria.desc(:created_at, :votes)
    @reviews = criteria.page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    data = {
      items: @reviews.inject([]){|memo, r| memo <<  {
        content: r.content,
        user_id: r.author.id,
        user_name: r.author.screen_name,
        user_avatar: r.author.get_avatar(true, false),
        user_reviews_cnt: r.author.reviews.count,
        user_established: current_user.relationships.select{|rel| rel.target_type == "User" && rel.target_id == r.author.id.to_s}.size > 0,
        time: r.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        picture_url: r.get_review_image_url,
        id: r.id}
      },
      page: params[:page],
      pages: (Review.all.size.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
    }

    respond_to do |format|
      format.json { render :json => data}
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
    if params[:product_id]
      product = Product.find(params[:product_id])
      @review = product.reviews.build
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

    ImagesHelper.process_uploaded_images(@review, params[:images])

    #handle products'' links
    @review.product_ids.each do |product_id|
      product = Product.find(product_id)
      product.review_ids ||= []
      product.review_ids << @review.id
      product.save
    end

    #RewardManager.new(current_user).contribute(:posted_reviews)

    #default value
    @remote_status = true
    @local_status = false
    @user_message = ''

    if params[:sync_to]
      @user_message, @remote_status = SyncsManager.new(current_user).sync(@review)
    end
    @local_status = @review.save if @remote_status

    respond_to do |format|
      if @local_status
        @user_message = t("notices.review_posted") + @user_message
        format.html { redirect_to(@review, :notice => @user_message) }
        format.js
      else
        @user_message = t("notices.review_post_failure") + @user_message
        format.html { render :action => "new", :notice => @user_message }
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

  def link
    @valid = false
    site = SilverHornet::ProductsSite.new
    url = site.handle_url(params[:product_url])
    if url
      @valid = true
      @product = Product.first(conditions: {url: url})

      if @product.nil?
        #It's not in our database, then fetch it now
        site.name = t("third_party.taobao")
        conf = YAML::load(ERB.new(IO.read("#{Rails.root}/config/silver_hornet/products.yml")).result)
        conf[t("third_party.taobao")].each do |key, value|
          site.send("#{key}=", value) if site.respond_to?("#{key}=")
        end

        site.agent = Mechanize.new
        site.agent.get(url)
        @product = site.process_product(nil)
      end
    end

    respond_to do |format|
      format.js
    end
  end
end
