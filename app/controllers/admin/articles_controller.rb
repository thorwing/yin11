class Admin::ArticlesController < Admin::BaseController
  uses_tiny_mce :only => [:new, :edit], :options => get_tiny_mce_style

  def index
    @articles = Article.desc(:created_at).page(params[:page]).per(GlobalConstants::ITEMS_PER_PAGE_MANY)
  end

  def show
    @article = Article.unscoped.find(params[:id])
  end

  def new
    @article = Article.new
    @article.build_source

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  def edit
    @article = Article.unscoped.find(params[:id])
    #@article.build_source unless @article.source
  end

  def create
    @article = Article.new(params[:article])
    @article.author_id = current_user.id

    begin
      respond_to do |format|
        if @article.save && @article.images.each(&:save)
          format.html { redirect_to([:admin, @article], :notice => t("notices.article_posted") ) }
          format.xml  { render :xml => @article, :status => :created, :location => @article }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
        end
      end
    rescue
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @article = Article.enabled.find(params[:id])

    begin
      respond_to do |format|
        if @article.update_attributes(params[:article])
          format.html { redirect_to([:admin, @article], :notice => t("notices.article_updated")) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
        end
      end
    rescue
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
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
