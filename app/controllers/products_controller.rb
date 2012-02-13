class ProductsController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :editor }

  # GET /products
  # GET /products.json
  def index
    @catalogs = Catalog.desc(:created_at).to_a
    @products, @total_chapters = get_products(params[:tag], params[:page])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    @products, dummy = get_products(params[:tag], params[:page])

    respond_to do |format|
      format.html
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    limit = 6
    @related_products = Product.tagged_with(@product.tags).limit(RELATED_RPODUCTS_LIMIT).reject{|p| p == @product}
    @refer_reviews = Review.all.desc(:created_at).any_in(product_ids: [params[:id]])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    if params[:vendor_id]
      vendor = Vendor.find(params[:vendor_id])
      @product = vendor.products.build
    else
      @product = Product.new
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :ok }
    end
  end

  private

  def get_products(tag, page, chapter = nil)
    total_chapters = 0
    if chapter.present?
      chapter = chapter.to_i
    elsif session[:current_products_chapter].present?
      chapter = session[:current_products_chapter].to_i
    else
      chapter = 1
    end
    page = (page ? page.to_i : 1)
    if page <= PAGES_PER_CHAPTER
      criteria = Product.enabled.without(:description)
      #if params[:catalog].present?
      #  catalog = Catalog.first(conditions: {name: params[:catalog]})
      #  catalog_ids = [catalog.id] | catalog.descendant_ids
      #  criteria = criteria.any_in(catalog_ids: catalog_ids)
      #end

      if tag.present? && tag != "null"
        criteria = criteria.tagged_with(tag)
      end
      total_chapters = (criteria.size.to_f / PAGES_PER_CHAPTER.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil

      return criteria.via_editor.page((chapter - 1) * PAGES_PER_CHAPTER + page).per(ITEMS_PER_PAGE_FEW), total_chapters
    else
      return [], total_chapters
    end
  end
end
