class Administrator::ProductsController < Administrator::BaseController
  before_filter() { |c| c.require_permission :editor}

  def index
    @products = Product.all.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
    #@disabled_products = Product.disabled.all
  end

  def show
    @product = Product.find(params[:id])
    @outgoing_count = Audit.where(url: @product.url).size
  end

  def edit
    @product = Product.find(params[:id])
  end

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

  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to [:administrator, @product], notice: 'Product was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

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

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to administrator_products_url }
      format.json { head :ok }
    end
  end

end
