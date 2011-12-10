class Administrator::PagesController < Administrator::BaseController

  def index
    @pages = Page.all.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
  end
end
