class PersonalController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def me
  end

  def my_feeds
      @feeds = current_user.feeds
      respond_to do |format|
        format.html  {render "get_feeds", :layout => "dialog"}
      end
  end

  def all_feeds
      @feeds = FeedsManager.pull_feeds(current_user)
      respond_to do |format|
        format.html  {render "get_feeds", :layout => "dialog"}
      end
  end

  def feeds
    #TODO
    @feeds = current_user.feeds #FeedsManager.pull_feeds(current_user, params[:page].to_i, ITEMS_PER_PAGE_FEW)
    total = 10

    data = {
      items: @feeds.inject([]){|memo, f| memo <<  {
        content: f.content,
        user_id: f.author.id,
        user_name: f.author.screen_name,
        user_avatar: f.author.get_avatar(true, false),
        user_reviews_cnt: f.author.reviews.count,
        user_established: current_user.relationships.select{|rel| rel.target_type == "User" && rel.target_id == f.author.id.to_s}.size > 0,
        time: f.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        picture_url: f.picture_url,
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
