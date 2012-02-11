class Administrator::PlacesController < Administrator::BaseController
  before_filter() { |c| c.require_permission :administrator}

  def index
    @places = Place.all.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
  end
end
