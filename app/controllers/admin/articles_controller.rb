class Admin::ArticlesController < Admin::BaseController
  def index
    @articles = Article.desc(:created_at).page(params[:page]).per(20)
  end

  def show
    @article = Article.unscoped.find(params[:id])
  end

  def edit
    @article = Article.unscoped.find(params[:id])
  end

  def update
  end

  def destroy
    @article = Article.unscoped.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(admin_articles_url) }
      format.xml  { head :ok }
    end
  end

end
