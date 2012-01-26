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
  end

  def feeds
    @feeds, total = FeedsManager.pull_feeds(current_user)

    #less than 1 page
    if total < ITEMS_PER_PAGE_FEW
      hot_tags= get_hot_tags(ITEMS_PER_PAGE_FEW, :feeds)
      extra_feeds, extra_total = FeedsManager.get_tagged_feeds(hot_tags)
      #TODO sometimes @feeds is nil
      @feeds ||= []
      extra_feeds ||= []
      @feeds =  @feeds + extra_feeds
      total += extra_total
    end

    page = params[:page].to_i
    #different pagination of waterfall, it starts from 1
    page = page -1 if page > 0

    @feeds = FeedsManager.process(@feeds)[(page * ITEMS_PER_PAGE_FEW)..((page + 1)* ITEMS_PER_PAGE_FEW)]

    data = {
      items: @feeds.inject([]){|memo, f| memo <<  {
        content: f.content,
        user_id: f.author.id,
        user_name: f.author.login_name,
        user_avatar: f.author.get_avatar(:thumb, false),
        user_reviews_cnt: f.author.reviews.count,
        user_recipes_cnt: f.author.recipes.count,
        user_fans_cnt: f.author.followers.count,
        user_established: current_user.relationships.select{|rel| rel.target_type == "User" && rel.target_id == f.author.id.to_s}.size > 0,
        target_path: url_for(f.item),
        time: f.created_at.strftime("%m-%d %H:%M:%S"),
        picture_url: f.picture_url(:waterfall),
        picture_height: f.picture_height(:waterfall),
        id: f.id}
      },
      page: params[:page],
      pages: (total.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
    }

    respond_to do |format|
      format.json { render :json => data}
    end
  end

end
