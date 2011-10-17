class Administrator::ArticlesController < Administrator::BaseController
  #uses_tiny_mce :only => [:new, :edit], :options => get_tiny_mce_style

  def index
    is_search = params[:q].present?
    criteria = is_search ? Article.where(:title => /#{params[:q]}?/) : Article.all
    criteria = criteria.desc(:reported_on, :updated_at).without(:content)
    @count = criteria.size
    @articles = is_search ? criteria.page(1).per(@count) : criteria.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
    @recommended_articles = Article.recommended.desc(:updated_at).all
  end
end
