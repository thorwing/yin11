class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    @recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)

    #TODO
    @stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..5]
    #@masters = User.enabled.masters.limit(40)

    @primary_tags = {}
    get_primary_tags.each do |lv, tags|
      if tags.is_a?(Array)
        tags.each{|t| @primary_tags[t] = Tag.find(t)}
      elsif tags.is_a?(Hash)
        tags.each do |key, value|
          value.each{|t| @primary_tags[t] = Tag.first(conditions: {name: t})}
        end
      end
    end

    @hot_primary_tags = Tag.any_in(name: get_top_primary_tags).to_a.sort{|x,y| get_top_primary_tags.index(x.name) <=> get_top_primary_tags.index(y.name) }

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

  def collect_intro

  end
end
