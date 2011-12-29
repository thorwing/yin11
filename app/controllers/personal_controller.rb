class PersonalController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def me
    #TODO why there are feed that doesn't belong to a user
    @my_feeds = FeedsManager.get_feeds_of(current_user)
  end

  def feeds
    @feeds, total = FeedsManager.pull_feeds(current_user, params[:page].to_i, ITEMS_PER_PAGE_FEW)

    if total < ITEMS_PER_PAGE_FEW
      hot_tags= get_hot_tags
      extra_feeds, extra_total = FeedsManager.get_tagged_feeds(hot_tags, params[:page].to_i, ITEMS_PER_PAGE_FEW)
      #TODO sometimes @feeds is nil
      @feeds ||= []
      extra_feeds ||= []
      @feeds =  @feeds + extra_feeds
      total += extra_total
    end

    #TODO why author is nil
    @feeds = @feeds.reject{|f| f.cracked?}.compact.uniq {|f| f.identity }

    data = {
      items: @feeds.inject([]){|memo, f| memo <<  {
        content: f.content,
        user_id: f.author.id,
        user_name: f.author.screen_name,
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
