class ReviewsController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}

  # GET /reviews
  # GET /reviews.xml
  def index
    #@hot_tags = get_hot_tags(14, :reviews)
    #@records = get_records

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    #  used for waterfall displaying
    criteria = Review.all.desc(:created_at)
    criteria = criteria.any_in(product_ids: [params[:product_id]]) if params[:product_id].present?
    criteria = criteria.tagged_with(params[:tag]) if params[:tag].present?
    @reviews = criteria.page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    data = {
      items: @reviews.inject([]){|memo, r| memo <<  {
        content: r.content,
        user_id: r.author.id,
        user_name: r.author.login_name,
        user_avatar: r.author.get_avatar(:thumb, false),
        user_reviews_cnt: r.author.reviews.count,
        user_recipes_cnt: r.author.recipes.count,
        user_fans_cnt: r.author.followers.count,
        user_established: current_user ? (current_user.relationships.select{|rel| rel.target_type == "User" && rel.target_id == r.author.id.to_s}.size > 0) : false,
        time: r.created_at.strftime("%m-%d %H:%M:%S"),
        picture_url: r.get_review_image_url(:waterfall),
        picture_height: r.get_review_image_height(:waterfall),
        id: r.id}
      },
      page: params[:page],
      pages: (criteria.size.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
    }

    respond_to do |format|
      format.json { render :json => data}
    end
  end

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])

    tags = []
    tags += @review.products.inject([]){|memo, p| memo + p.tags} if @review.products
    tags += @review.recipe.tags if @review.recipe

    @related_products = Product.tagged_with(tags).limit(RELATED_RPODUCTS_LIMIT).reject{|p| p == @product}

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
    #default value
    @remote_status = true
    @local_status = false
    @user_message = ''

    #prevent from mistakes ( two reviews in a row)

    if Cooler.nervous_reviewer?(current_user, params[:review][:content])
      @user_message = t("notices.already_published")
      respond_to do |format|
        format.html { render :action => "new", :notice => @user_message }
        format.js
      end

      return
    end

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

    #handle album
    @review.album_ids.each do |album_id|
      album = Album.find(album_id)
      album.review_ids ||= []
      album.review_ids << @review.id
      album.save
    end

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

    ImagesHelper.process_uploaded_images(@review, params[:images])

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
    site = SilverHornet::ProductsSite.new(true)
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
