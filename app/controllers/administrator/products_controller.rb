class Administrator::ProductsController < Administrator::BaseController
  before_filter() { |c| c.require_permission :administrator}

  def index
    @products = Product.all.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
    #@disabled_products = Product.disabled.all
  end
end
