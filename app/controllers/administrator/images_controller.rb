class Administrator::ImagesController < Administrator::BaseController

  def index
    criteria = Image.all.desc(:updated_at)
    criteria = criteria.lonely if params[:lonely] && params[:lonely] == true

    @images = criteria.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
  end
end