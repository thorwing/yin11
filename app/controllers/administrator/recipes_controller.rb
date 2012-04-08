class Administrator::RecipesController < Administrator::BaseController
  before_filter() { |c| c.require_permission :editor}

  def index
    @recipes = Recipe.all.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to administrator_recipes_path}
      format.json { head :ok }
    end
  end


end
