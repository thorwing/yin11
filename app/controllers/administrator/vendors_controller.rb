class Administrator::VendorsController < Administrator::BaseController
  def index
    @vendors = Vendor.page(params[:page]).per(ITEMS_PER_PAGE_MANY)

    #@disabled_vendors = Vendor.disabled.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vendors }
    end
  end
end
