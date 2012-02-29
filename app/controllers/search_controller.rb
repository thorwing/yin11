class SearchController < ApplicationController
  #before_filter :prepare

  #def test_xs(str, escape=true)
  #    str.unpack('U*').map {|n| n.xchr(escape)}.join # ASCII, UTF-8
  #  rescue
  #    str.unpack('C*').map {|n| n.xchr}.join # ISO-8859-1, WIN-1252
  #end

  def index
    @users = []
    @recipes = []
    @desires = []
    @query = params[:query] || ""
    @empty = true

    #SilverSphinx.context.indexed_models.each do |model|
    #  model = model.constantize
    #  @items |= model.search(params[:query]).documents
    #end

    if @query.present?
      case params[:scope]
        when "users"
          @users = User.search(@query).documents.sort{|x, y|(y.score <=> x.score)} unless @users.empty?
        when "desires"
          @desires = Desire.search(@query).documents.sort{|x, y|(y.created_at <=> x.created_at)}
        when "recipes"
          @recipes = Recipe.search(@query).documents.sort{|x, y|(y.created_at <=> x.created_at)}
        else
          @users = User.search(@query).documents.sort{|x, y|(y.score <=> x.score)}
          @desires = Desire.search(@query).documents.sort{|x, y|(y.created_at <=> x.created_at)}
          @recipes = Recipe.search(@query).documents.sort{|x, y|(y.created_at <=> x.created_at)}
      end

      @empty = @users.empty? && @recipes.empty? && @desires.empty?
    end
  end

end