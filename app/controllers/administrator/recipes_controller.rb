class Administrator::RecipesController < Administrator::BaseController
  before_filter() { |c| c.require_permission :administrator}

  def index
    @recipes = Recipe.all.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
  end
end
