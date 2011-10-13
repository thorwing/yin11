class Admin::ArticlesController < Admin::BaseController
  #uses_tiny_mce :only => [:new, :edit], :options => get_tiny_mce_style

  def index
    is_search = params[:q].present?
    criteria = is_search ? Article.where(:title => /#{params[:q]}?/) : Article.all
    criteria = criteria.desc(:reported_on, :updated_at).without(:content)
    @count = criteria.size
    @articles = is_search ? criteria.page(1).per(@count) : criteria.page(params[:page]).per(ITEMS_PER_PAGE_MANY)
    @recommended_articles = Article.recommended.desc(:updated_at).all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    @article.build_source(:name => t("articles.default_source_name"))

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  def edit
    @article = Article.find(params[:id])
    #@article.build_source unless @article.source
  end

  def create
    @article = Article.new(params[:article])
    @article.author_id = current_user.id

    ImagesHelper.process_uploaded_images(@article, params[:images])

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
    @article = Article.find(params[:id])

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
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(admin_articles_url) }
      format.xml  { head :ok }
    end
  end

end
