class HomeController < ApplicationController
  include ApplicationHelper
  before_filter :get_items

  def index
    #TODO
    #the last item is not displayed in s3slider
    @articles = Article.enabled.recommended.desc(:reported_on, :updated_at).limit(HOT_ARTICLES_ON_HOME_PAGE).all

    @raw_hot_tags = CacheManager.hot_tags_with_weight
    #for default search query

    @default_query = (@raw_hot_tags.nil? || @raw_hot_tags.empty?) ? "" : @raw_hot_tags.first[0]

    #data for control panel
    if current_user
      #@evaluation = current_user.get_evaluation
      #TODO
      #should be loaded on demand
      @watched_tags = current_user.profile.watched_tags
      @collected_tips = Tip.any_in(:_id => current_user.profile.collected_tip_ids).all
      @my_groups = current_user.groups.all
      @watched_locations = current_user.profile.watched_locations
    end

    #TODO
    if current_user && current_user.profile.watched_locations.empty?
      city_center = Location.new(:city => current_city.name, :street => t("location.city_center")) do |l|
        l.coordinates = [current_city.longitude, current_city.latitude]
      end
      current_user.profile.watched_locations << city_center
      current_user.profile.save
      @watched_locations = [city_center]
    end

    @watched_locations = @watched_locations.group_by(&:city) if @watched_locations.present?

    @panel_manager = PanelManager.new(current_user)
  end

  # get more items for pagination on home page
  def more_items
    #TODO
    #prvent "display more links" from being displayed multiple times

    respond_to do |format|
      format.html {render :more_items, :layout => false}
    end
  end

  protected

  def get_items
    page_number = params[:page].present? ? params[:page] : 1
    criteria = InfoItem.enabled
    has_block_list = (current_user && current_user.blocked_user_ids && current_user.blocked_user_ids.size > 0)
    criteria =  criteria.not_from_blocked_users(current_user.blocked_user_ids) if has_block_list

    popular_items = criteria.desc(:votes).page(page_number).per(ITEMS_PER_PAGE_POPULAR)
    topic_items = criteria.tagged_with(CacheManager.hot_tags).page(page_number).per(ITEMS_PER_PAGE_HOT)
    recent_items = criteria.desc(:created_at, :reported_on).page(page_number).per(ITEMS_PER_PAGE_RECENT)

    if current_user
      user_ids = current_user.members_from_same_group
      group_items = criteria.any_in(:author_id => user_ids).page(page_number).per(ITEMS_PER_PAGE_GROUP)
    end

    items = popular_items | topic_items | recent_items
    items |= group_items if current_user

    evaluator = EvaluationManager.new(current_user)
    scored_items = items.inject([]) {|memo, e| memo << [evaluator.get_score_of_item(e), e]}

    @items = scored_items.sort {|a,b| b[0]<=>a[0]}.inject([]){|memo, e| memo << e[1]}
  end

end
