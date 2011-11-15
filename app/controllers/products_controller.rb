class ProductsController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :editor }

  # GET /products
  # GET /products.json
  def index
    criteria = Product.enabled
    if params[:category].present?
      category = Tag.first(conditions: {name: params[:category], is_category: true})
      categories = [category.name]
      categories |= category.children.map{|c| c.name} unless category.children.empty?

      criteria = criteria.tagged_with(categories)
    end
    @catalogs = Catalog.all
    @products = criteria.page(params[:page]).per((ITEMS_PER_PAGE_MANY / 3).to_i * 3)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    @rel_tips = Article.tips.tagged_with(@product.tags)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  ## GET /products/new
  ## GET /products/new.json
  #def new
  #  if params[:vendor_id]
  #    vendor = Vendor.find(params[:vendor_id])
  #    @product = vendor.products.build
  #  else
  #    @product = Product.new
  #  end
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @product }
  #  end
  #end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  ## POST /products
  ## POST /products.json
  #def create
  #  @product = Product.new(params[:product])
  #
  #  respond_to do |format|
  #    if @product.save
  #      format.html { redirect_to @product, notice: 'Product was successfully created.' }
  #      format.json { render json: @product, status: :created, location: @product }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @product.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

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
end
