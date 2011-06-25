class ArticlesController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :editor }
  uses_tiny_mce :only => [:new, :edit], :options => get_tiny_mce_style

  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.enabled.desc(:reported_on, :updated_on).page(params[:page]).per(GlobalConstants::ITEMS_PER_PAGE_MANY)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.enabled.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    @article.build_source

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.enabled.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    begin
      respond_to do |format|
        if @article.save && @article.images.each(&:save)
          format.html { redirect_to(@article, :notice => t("articles.article_posted_notice") ) }
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

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.enabled.find(params[:id])

    begin
      respond_to do |format|
        if @article.update_attributes(params[:article])
          format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
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

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.enabled.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end

end
