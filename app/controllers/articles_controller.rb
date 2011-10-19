class ArticlesController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :editor }
  layout "two_columns"

  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.enabled.desc(:reported_on, :updated_on).page(params[:page]).per(ITEMS_PER_PAGE_MANY)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    #TODO
    if current_user_has_permission? :editor
      @article = Article.find(params[:id])
    else
      @article = Article.enabled.find(params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
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
          format.html { redirect_to(@article, :notice => t("notices.article_posted") ) }
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
          format.html { redirect_to(@article, :notice => t("notices.article_updated")) }
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
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end


end
