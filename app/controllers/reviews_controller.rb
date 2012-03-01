class ReviewsController < ApplicationController
  before_filter(:except => [:show]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Review.name, c.params[:id], true)}

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])

    tags = []
    tags += @review.products.inject([]){|memo, p| memo + p.tags} if @review.products
    tags += @review.recipes.inject([]){|memo, r| memo + r.tags} if @review.recipes

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

    #handle recipes'' links
    @review.recipe_ids.each do |recipe_id|
      recipe = Recipe.find(recipe_id)
      recipe.review_ids ||= []
      recipe.review_ids << @review.id
      recipe.save
    end

    if params[:sync_to]
      @user_message, @remote_status = SyncsManager.new(current_user).sync(@review)
    end
    @local_status = @review.save if @remote_status

    respond_to do |format|
      if @local_status
        @user_message = t("notices.review_posted") + @user_message
        format.html { redirect_to(:back, :notice => @user_message) }
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
    @valid_url, @product = handle_taobao_product(params[:product_url])

    respond_to do |format|
      format.js
    end
  end
end
