class HomeController < ApplicationController
  include ApplicationHelper

  def index

    @items = get_items(1)

    @hot_articles = Article.enabled.desc(:reported_on, :updated_on).limit(GlobalConstants::HOT_ARTICLES_ON_HOME_PAGE)

    @my_tips = current_user ? current_user.collected_tips.all : []
    @my_groups = current_user ? current_user.groups.all : []
    #TODO
    @foods_buzz = []#Food.desc([:review_ids, :article_ids]).limit(5).group_by{ |f| f.categories[0] }
  end

  # get more items for pagination on home page
  def more_items
    @items = get_items(params[:page])
    respond_to do |format|
      format.html {render :more_items, :layout => false}
    end
  end

  def items
    #prepare parameters
    if params[:search].present?
      @tags = params[:search].split(" ") || []
      @tags.each do |q|
        @region = City.first(:conditions => {:name => q})
        @region = Province.first(:conditions => {:name => q}) unless @region
        if @region
          @region_id = @region.id
          @tags.reject!{|e| e == q}
          break
        end
      end
    else
      (@tags = params[:tags].is_a?(Array) ?  params[:tags] : [params[:tags]]) if params[:tags].present?
      @region_id = params[:region_id]
    end

    @bad_items = InfoItem.bad.enabled
    @good_items = InfoItem.good.enabled
    if @tags && @tags.size > 0
      @bad_items = @bad_items.tagged_with(@tags)
      @good_items = @good_items.tagged_with(@tags)
    end

    #search based on location
    if @region_id.present?
      @bad_items = @bad_items.of_region(@region_id)
      @good_items = @good_items.of_region(@region_id)
      @region ||= get_region(@region_id)
    end

    @bad_count = @bad_items.size
    @good_count = @good_items.size
    @bad_regions = @bad_items.inject([]) {|memo, e| memo | (e.region_ids || []).map{|id| get_region(id)} }.uniq.delete_if{|e| e.code == "ALL"}

    @bad_items = @bad_items.desc(:reported_on, :updated_on).page(params[:page]).per(GlobalConstants::ITEMS_PER_PAGE_FEW)
    @good_items = @good_items.desc(:reported_on, :updated_on).page(params[:page]).per(GlobalConstants::ITEMS_PER_PAGE_FEW)

    targets = []
    targets = @tags if @tags
    targets << @region.name if @region

    @target_names = targets.join(",")
  end

  def regions
    @regions = Province.only(:id, :name).where(:name => /#{params[:q]}?/) + City.only(:id, :name).where(:name => /#{params[:q]}?/)
    @regions.uniq! {|e| e.name}
    respond_to do |format|
      format.json { render :json => @regions.map { |e| {:id => e.id, :name => e.name } } }
    end
  end

  def cities
      province = Province.first(:conditions => {:id => params[:province_id]}) if params[:province_id]
      @cities = province.cities if province
      @cities ||= []

      respond_to do |format|
        format.json { render :json => @cities.map { |e| {:id => e.id, :name => e.name } } }
    end
  end

  def watch_foods
    current_user.profile.add_foods(params[:added_foods].split(","))
    current_user.save

    respond_to do |format|
      format.html {redirect_to :back}
    end
  end

  def vote
    @item = get_item_based_on(params[:type], params[:id])

    delta = params[:delta].to_i

    first_vote = false

    if delta > 0
      if @item.fan_ids.include?(current_user.id)
        delta *= -1
        @item.fan_ids.delete(current_user.id)
      elsif @item.hater_ids.include?(current_user.id)
        @item.hater_ids.delete(current_user.id)
      else
        @item.fan_ids << current_user.id
        first_vote = true
      end
    else
      if @item.hater_ids.include?(current_user.id)
        delta *= -1
        @item.hater_ids.delete(current_user.id)
      elsif @item.fan_ids.include?(current_user.id)
        @item.fan_ids.delete(current_user.id)
      else
        @item.hater_ids << current_user.id
        first_vote = true
      end
    end

    weight = delta * current_user.vote_weight
    @item.votes += weight
    @votes = @item.votes

    current_user.make_contribution(:total_up_votes, 1) if first_vote && weight > 0
    current_user.make_contribution(:total_down_votes, 1) if first_vote && weight < 0

    @is_fan = @item.fan_ids.include?(current_user.id)
    @is_hater = @item.hater_ids.include?(current_user.id)

    respond_to do |format|
      if @item.save
        format.html {redirect_to :root }
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { redirect_to @item }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end
  end

  def new_comment
    @item = get_item_based_on(params[:type], params[:id])
    if params[:parent_comment_id].present?
      parent_comment = @item.comments.find(params[:parent_comment_id])
      @comment = parent_comment.children.build(:content => params[:content])
    else
      @comment = Comment.new(:content => params[:content])
    end
  end

  def add_comment
    item = get_item_based_on(params[:type], params[:id])
    if params[:parent_comment_id].present?
      parent_comment = item.comments.find(params[:parent_comment_id])
      new_comment = parent_comment.children.build(:content => params[:content], :user_id => current_user.id)
      #parent_comment.children.create(:content => params[:content], :user_id => current_user.id)
      item.comments << new_comment
      #item.comments << Comment.create(:content => params[:content], :user_id => current_user.id, :parent_id => parent_comment.id)
    else
      item.comments ||= []
      item.comments << Comment.new(:content => params[:content], :user_id => current_user.id)
    end

     respond_to do |format|
        format.html {redirect_to item}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
    end
  end

  protected
  def get_item_based_on(type, id)
    begin
      eval("#{type}.unscoped.find(id)")
    rescue
       raise "not supported type: " + type
    end
  end

  def get_items(page_idx)
    #fetch items, according to popularity, topics(tags) and recent
    basic_criteria = InfoItem.enabled.in_days_of(GlobalConstants::ITEMS_EFFECTIVE_DAYS)
    basic_criteria = basic_criteria.not_from_blocked_users(current_user.blocked_user_ids) if (current_user and current_user.blocked_user_ids)
    popular_items = basic_criteria.desc(:votes).page(page_idx).per(GlobalConstants::ITEMS_PER_PAGE_POPULAR)
    hot_items = basic_criteria.tagged_with_any(get_hot_tags).desc(:created_at, :reported_on).page(page_idx).per(GlobalConstants::ITEMS_PER_PAGE_HOT)
    recent_items = basic_criteria.desc(:created_at, :reported_on).page(page_idx).per(GlobalConstants::ITEMS_PER_PAGE_RECENT)
    if current_user
      user_ids = current_user.groups.inject([]) {|memo, group| memo | group.user_ids }
      group_items = basic_criteria.any_in(:author_id => user_ids).desc(:created_at, :reported_on).page(page_idx).per(GlobalConstants::ITEMS_PER_PAGE_GROUP)
    end

    items = popular_items | hot_items | recent_items
    items |= group_items if current_user

    items_with_score = {}
    items.each do |item|
      score = get_score_of_item(item)
      items_with_score[score] ||= []
      items_with_score[score] << item
    end
    items_with_score.sort {|a,b| a[0]<=>b[0]}.inject([]){|memo, (k, v)| memo + v}
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
    if current_user
      user_ids = current_user.groups.inject([]) {|memo, group| memo | group.user_ids }
      user_ids.include? item.author_id
    else
      false
    end
  end
end
