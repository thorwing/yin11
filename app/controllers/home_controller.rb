class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    @recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)

    #TODO
    @daily_stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..2]
    @masters = User.enabled.masters.limit(40)
  end

  # get more items for pagination on home page
  def more_items
    respond_to do |format|
      format.html {render :more_items, :layout => false}
    end
  end

  def gateway
    user_ip = request.remote_ip
    user_id = current_user ? current_user.id : nil
    product_url = params[:url]

    @audit = Audit.create(:user_ip => user_ip, :user_id => user_id, :product_url => product_url )
    redirect_to product_url
  end

end
