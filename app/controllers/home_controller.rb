class HomeController < ApplicationController

  def index
    @items = InfoItem.enabled.desc(:reported_on, :updated_on).page(1).per(GlobalConstants::ITEMS_PER_PAGE_MANY)
    @hot_articles = Article.enabled.desc(:reported_on, :updated_on).limit(GlobalConstants::HOT_ARTICLES_ON_HOME_PAGE)

    @my_tips = current_user ? current_user.collected_tips.all : []
    @my_groups = current_user ? current_user.groups.all : []
    #TODO
    @foods_buzz = []#Food.desc([:review_ids, :article_ids]).limit(5).group_by{ |f| f.categories[0] }
  end

  # get more items for pagination on home page
  def more_items
    @items = InfoItem.enabled.desc(:reported_on).page(params[:page]).per(GlobalConstants::ITEMS_PER_PAGE_MANY)
    respond_to do |format|
      format.html {render :more_items, :layout => false}
    end
  end

  def items
    #prepare parameters
    if params[:search].present?
      @tags = params[:search].split(" ") || []
      @tags.each do |q|
        @region = City.first(conditions: {name: q})
        @region = Province.first(conditions: {name: q}) unless @region
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
      province = Province.first(conditions: {id: params[:province_id]}) if params[:province_id]
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

    weight = delta * get_vote_weight_of_current_user
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

  def get_info_items(page, per)
    result = []
    if current_user && current_user.profile.watching_foods.size > 0
      for id in current_user.profile.watching_foods do
        food = Food.find(id)
        food_info = []
        food_info = get_related_reviews_of(food).inject([]){ |info_array, review| info_array << review } if current_user.profile.display_reviews
        #TODO
        food_info += get_related_articles_of(food, current_user).inject([]){ |info_array, article| info_array << article } if current_user.profile.display_articles
        result |= food_info.sort{ |a, b| a.votes <=> b.votes}.reverse()[0..2]
      end
    else
      result = Review.desc(:reported_on).page(page).per(per/2) + Article.enabled.desc(:reported_on).per(per/2)
      result = result.sort!{ |a, b| a.votes <=> b.votes}.reverse()[0..4]
    end
    result
  end
end
