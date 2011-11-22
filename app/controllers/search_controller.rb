class SearchController < ApplicationController
  #before_filter :prepare

  #def test_xs(str, escape=true)
  #    str.unpack('U*').map {|n| n.xchr(escape)}.join # ASCII, UTF-8
  #  rescue
  #    str.unpack('C*').map {|n| n.xchr}.join # ISO-8859-1, WIN-1252
  #end

  def index
    @users = []
    @articles = []
    @products = []
    @empty = true
    @query = ""

    if params[:query]
      #SilverSphinx.context.indexed_models.each do |model|
      #  model = model.constantize
      #  @items |= model.search(params[:query]).documents
      #end
      @query = params[:query]
      case params[:scope]
        when "users"
          @users = User.search(@query).documents
          @empty = @user.empty?
        when "articles"
          @articles = Article.search(@query).documents
          @empty = @articles.empty?
        when "products"
          @products = Product.search(@query).documents
          @empty = @products.empty?
        else
          @users = User.search(@query).documents
          @products = Product.search(@query).documents
          @empty = @products.empty? && @users.empty?
      end
    elsif params[:tags]
      @query = params[:tags]
      query_tags = params[:tags].split(' ')
      @products = Product.tagged_with(query_tags)
      @articles = Article.tagged_with(query_tags)
      @empty = @products.empty? && @articles.empty?
    end
  end

end