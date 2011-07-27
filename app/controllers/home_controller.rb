class HomeController < ApplicationController
  include ApplicationHelper
  before_filter :get_items

  def index
    @articles = Article.enabled.recommended.desc(:reported_on, :updated_on).limit(HOT_ARTICLES_ON_HOME_PAGE)

    #data for control panel
    if current_user
      #@updates = get_updates
      #TODO
      #should be loaded on demand
      @watched_tags = current_user.profile.watched_tags
      @collected_tips = Tip.any_in(:_id => current_user.profile.collected_tip_ids).all
      @my_groups = current_user.groups.all
      @watched_locations = current_user.profile.watched_locations
    end
  end

  # get more items for pagination on home page
  def more_items
    respond_to do |format|
      format.html {render :more_items, :layout => false}
    end
  end

  protected

  def get_items
    page_number = params[:page].present? ? params[:page] : 1
    criteria = InfoItem.enabled
    hsa_block_list = (current_user && current_user.blocked_user_ids && current_user.blocked_user_ids.size > 0)
    criteria =  criteria.not_from_blocked_users(current_user.blocked_user_ids) if hsa_block_list

    popular_items = criteria.desc(:votes).page(page_number).per(ITEMS_PER_PAGE_POPULAR)
    topic_items = criteria.tagged_with(get_hot_tags).page(page_number).per(ITEMS_PER_PAGE_HOT)
    recent_items = criteria.desc(:created_at, :reported_on).page(page_number).per(ITEMS_PER_PAGE_RECENT)

    if current_user
      user_ids = current_user.members_from_same_group
      group_items = criteria.any_in(:author_id => user_ids).page(page_number).per(ITEMS_PER_PAGE_GROUP)
    end

    items = popular_items | topic_items | recent_items
    items |= group_items if current_user

    scored_items = items.inject({}) {|memo, e| memo.merge({ e => get_score_of_item(e)}) }

    @items = scored_items.sort {|a,b| a[1]<=>b[1]}.inject([]){|memo, (k, v)| memo << k}
  end

  def get_score_of_item(item)
    score = 0
    score += item.votes * 10 #popularity
    score += (get_hot_tags | item.tags).size * 100 if item.tags #topics
    score += 100 if item.is_recent? #recent
    score += 300 if is_from_my_groups?(item) #groups
    score
  end

  #check whether the item is created by a member of my groups
  def is_from_my_groups?(item)
    if current_user && current_user.members_from_same_group.include?(item.author_id)
      true
    else
      false
    end
  end
end
