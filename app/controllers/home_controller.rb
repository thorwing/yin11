class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    @recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)

    #TODO
    @stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..2]
    #@masters = User.enabled.masters.limit(40)

    @hot_primary_tags = Tag.where(primary: true, :desires_count.gt => 0).desc(:desires_count).limit(7).to_a

    more_desires = Desire.recommended.tagged_with(@hot_primary_tags.map(&:name))
    result = {}
    @hot_primary_tags.each do |tag|
      result[tag.name] = more_desires.select{|d| d.tags.include?(tag.name)}.take(10)
    end
    @hot_primary_tags.reject!{|t| result[t.name].empty?}
    @desires = result.inject([]){|memo, (key, values)| memo | values}.compact.uniq

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
