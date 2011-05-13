class WikiController < ApplicationController
  before_filter(:only => [:new]) { |c| c.require_permission :user }
  before_filter :connect_to_model, :load_page
  layout "wiki_default"

  def self.wiki
    Wiki.new
  end

  def index
    @categories = WikiCategory.all.sort
  end

  def list
    @categories = WikiCategory.all.sort
    @category = params['category']
    if @category
      @set_name = "category '#{@category}'"
      @pages_in_category = @category.pages.sort
    else
      # no category specified, return all pages of the web
      @pages_in_category = WikiPage.all
      @set_name = 'all'
    end
  end

  def page_list
    @pages = params[:q] ? WikiPage.where(:title => /#{params[:q]}?/) : WikiPage.all

    respond_to do |format|
      format.json { render :json => @pages.map { |p| {:id => p.id, :name => p.title} } }
    end
  end

  def show
    if @page
      begin
        @renderer = PageRenderer.new(@page.revisions.last)
        @show_diff = (params[:mode] == 'diff')
        # TODO this rescue should differentiate between errors due to rendering and errors in
        # the application itself (for application errors, it's better not to rescue the error at all)
      rescue => e
        logger.error e
        flash[:error] = e.to_s

        redirect_to :action => 'new', :title => @page_title
      end
#    elsif @page_name.present?
#        real_page = WikiReference.page_that_redirects_for(@page_name)
#        if real_page
#          flash[:info] = "Redirected from \"#{@page_name}\"."
#          redirect_to :web => @web_name, :action => 'show', :id => real_page, :status => 301
#        else
#          flash[:info] = "Page \"#{@page_name}\" does not exist.\n" +
#                         "Please create it now, or hit the \"back\" button in your browser."
#          redirect_to :web => @web_name, :action => 'new', :id => @page_name
#        end
#      else
#        render :text => 'Page name is not specified', :status => 404, :layout => 'error'
#      end
    end
  end

  def new

  end

  def save
    @page = WikiPage.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = t("wiki.created_page_notice")
        format.html { redirect_to :action => "show", :title => @page.title }
      else
        format.html { redirect_to :action => "index" }
      end
    end
  end

  def search
    @query = params['query']
    @title_results = WikiPage.where(:title => /#{@query}?/)
    @content_results = WikiPage.where(:content => /#{@query}?/)
    @all_pages_found = @title_results | @content_results
    if @all_pages_found.size == 1
      redirect_to_page(@all_pages_found.first.title)
    end
  end

  def edit

  end

  # Within a single page --------------------------------------------------------

  protected
  def connect_to_model
    @action_name = params['action'] || 'index'
    @wiki = wiki
  end

  def wiki
    self.class.wiki
  end

  def redirect_to_page(page_title)
    redirect_to :action => 'show', :title=> page_title
  end

  def load_page
    @page_title = params['title']
    ApplicationController.logger.debug "Reading page '#{@page_title}'"
    @page = WikiPage.first(conditions: { title: @page_title })
    ApplicationController.logger.debug "Page '#{@page_title}' #{@page.nil? ? 'not' : ''} found"
  end

  private

end
