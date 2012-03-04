class PersonalController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def me
    @modes = ["default", "desires",  "recipes", "albums"]
    if @modes.include? params[:mode]
      @current_mode = params[:mode]
    elsif @modes.include? session[:personal_mode]
      @current_mode = session[:personal_mode]
    else
       @current_mode = "default"
    end
    session[:personal_mode] = @current_mode
    page = params[:page].present? ? params[:page].to_i : 0

    case @current_mode
      when "recipes"
        @my_recipes = current_user.recipes.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
      when "albums"
        @my_albums = current_user.albums.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
      when "desires"
        @my_desires = current_user.desires.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
      else
        @feeds = get_feeds(params[:page]) || []
    end
  end

  def more_feeds
    @feeds = get_feeds(params[:page]) || []

    respond_to do |format|
      format.html {render :more_feeds, :layout => false}
    end
  end

  def favorites
    @modes = ["desires", "recipes", "albums"]
    if @modes.include? params[:mode]
      @current_mode = params[:mode]
    #elsif @modes.include? session[:personal_mode]
    #  @current_mode = session[:personal_mode]
    else
       @current_mode = "desires"
    end
    session[:personal_mode] = @current_mode
    page = params[:page].present? ? params[:page].to_i : 0

    @liked_recipes = Recipe.any_in(_id: current_user.liked_recipe_ids).desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @liked_albums = Album.any_in(_id: current_user.liked_album_ids).desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @admired_desires = current_user.admired_desires.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
  end

  private
  def get_feeds(page)
    page = page ? page.to_i : 1
    FeedsManager.pull_feeds(current_user)[((page - 1) * ITEMS_PER_PAGE_FEW)..((page)* ITEMS_PER_PAGE_FEW)]
  end

end
