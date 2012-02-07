class PersonalController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def me
    @modes = ["default", "desires", "reviews", "albums", "recipes"]
    if params[:mode].present?
      @current_mode = params[:mode]
    elsif session[:personal_mode].present?
      @current_mode = session[:personal_mode]
    else
       @current_mode = "default"
    end
    session[:personal_mode] = @current_mode
    page = params[:page].present? ? params[:page].to_i : 0
    #TODO why there are feed that doesn't belong to a user
    @my_reviews = current_user.reviews.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @my_recipes = current_user.recipes.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @my_albums = current_user.albums.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @my_desires = current_user.desires.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)

    @feeds = get_feeds(params[:page])
  end

  def more_feeds
    @feeds = get_feeds(params[:page])

    respond_to do |format|
      format.html {render :more_feeds, :layout => false}
    end
  end

  def favorites
    @modes = ["desires", "recipes", "albums", "products" ]
    if params[:mode].present?
      @current_mode = params[:mode]
    elsif session[:personal_mode].present?
      @current_mode = session[:personal_mode]
    else
       @current_mode = "desires"
    end
    session[:personal_mode] = @current_mode
    page = params[:page].present? ? params[:page].to_i : 0

    @liked_recipes = Recipe.any_in(_id: current_user.liked_recipe_ids).desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @liked_albums = Album.any_in(_id: current_user.liked_album_ids).desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @liked_products = Product.any_in(_id: current_user.liked_product_ids).desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    @admired_desires = current_user.admired_desires.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
  end

  private
  def get_feeds(page)
    page = page ? page.to_i : 1
    FeedsManager.pull_feeds(current_user)[((page - 1) * ITEMS_PER_PAGE_FEW)..((page)* ITEMS_PER_PAGE_FEW)].reject{|f| f.cracked? || f.created_at.blank?}.sort{|x, y| y.created_at <=> x.created_at}
  end

end
