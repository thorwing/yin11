class HomeController < ApplicationController
  include ApplicationHelper

  def index
    #@hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    @recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)
    @stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..7]
    configured_tags = get_desired_tags_config
    @desired_tags = Tag.any_in(name: configured_tags).sort_by {|tag| -1 * configured_tags.index(tag.name)}

    more_desires = Desire.recommended.tagged_with(@desired_tags.map(&:name)).desc(:priority)
    result = {}
    @desired_tags.each do |tag|
      result[tag.name] = more_desires.select{|d| d.tags.include?(tag.name)}.take(10)
    end
    @desired_tags.reject!{|t| result[t.name].empty?}
    @desires = result.inject([]){|memo, (key, values)| memo | values}.compact.uniq

    @primary_tags = get_primary_tags
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

  def collect_intro

  end
end
