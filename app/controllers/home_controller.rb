class HomeController < ApplicationController
  include ApplicationHelper

  def index
    #@hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    @recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)
    @stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..7]

    @desired_tags = get_desired_tags
    @desires = @desired_tags.inject([]){|memo, (k, v)| memo | v }.compact.uniq
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

  private

  def get_desired_tags
    #the default way:
    #configured_tags = get_desired_tags_config
    #@desired_tags = Tag.any_in(name: configured_tags).sort_by {|tag| configured_tags.index(tag.name)}
    #
    #more_desires = Desire.recommended.tagged_with(@desired_tags.map(&:name)).desc(:priority)
    #result = {}
    #@desired_tags.each do |tag|
    #  result[tag.name] = more_desires.select{|d| d.tags.include?(tag.name)}.take(10)
    #end
    #@desired_tags.reject!{|t| result[t.name].empty?}
    #@desires = result.inject([]){|memo, (key, values)| memo | values}.compact.uniq
    desired_tags = Rails.cache.fetch('desired_tags')
    if desired_tags.nil?
      desired_tags = {}
      desires = Desire.where(:priority.gte => 0).excludes(tags: []).desc(:created_at)
      desires.each do |desire|
        #pick the first tag to avoid duplication...
        tag = desire.tags.first
        desired_tags[tag] ||= []
        desired_tags[tag] << desire
      end

      top_tags = desired_tags.inject({}){|memo, (k, v)| memo[k] = v.size; memo}.sort_by{|k, v| -1 * v}.map{|i| i[0]}.take(7)
      #modify the tag to avoid duplication...
      desired_tags = top_tags.inject({}){|memo, tag| memo[tag] = desired_tags[tag].sort{|a, b| b.created_at <=> a.created_at}.take(10).each{|d| d.tags = [tag]}; memo}
      #raise desired_tags.to_yaml
      Rails.cache.write('desired_tags', nil, :expires_in => 2.hours) if Rails.env.production?
    end

    return desired_tags
  end
end
