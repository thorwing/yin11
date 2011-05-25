class HomeController < ApplicationController

  def index
    @watching_foods = []

    if current_user && current_user.profile.watching_foods.size > 0
      #TODO
      @watching_foods = Food.any_in(name: current_user.profile.watching_foods)
      @interested_info = {}
      for id in current_user.profile.watching_foods do
        food = Food.find(id)
        food_info = []
        food_info = get_related_reviews_of(food).inject([]){ |info_array, review| info_array << review } if current_user.profile.display_reviews
        #TODO
       # raise get_related_articles_of(food, current_user).size.to_s
        food_info += get_related_articles_of(food, current_user).inject([]){ |info_array, article| info_array << article } if current_user.profile.display_articles
        @interested_info[food.name] = food_info.sort{ |a, b| a.votes <=> b.votes}.reverse()[0..2]
      end
    else
      @recent_info = []
      @recent_info = Review.desc(:updated_at)[0..9] + Article.desc(:updated_at)[0..9]
      @recent_info = @recent_info.sort!{ |a, b| a.votes <=> b.votes}.reverse()[0..4]
    end

    #TODO
    @foods_buzz = Food.desc([:review_ids, :article_ids]).limit(5).group_by{ |f| f.categories[0] }
  end

  def watch_foods
    current_user.profile.add_foods(params[:added_foods].split(","))
    current_user.save

    respond_to do |format|
      format.html {redirect_to :back}
    end
  end

  def vote
    object = get_item_based_on(params[:type], params[:id])

    delta = params[:delta].to_i

    if delta > 0
      if object.fan_ids.include?(current_user.id)
        delta *= -1
        object.fan_ids.delete(current_user.id)
      elsif object.hater_ids.include?(current_user.id)
        object.hater_ids.delete(current_user.id)
      else
        object.fan_ids << current_user.id
      end
    else
      if object.hater_ids.include?(current_user.id)
        delta *= -1
        object.hater_ids.delete(current_user.id)
      elsif object.fan_ids.include?(current_user.id)
        object.fan_ids.delete(current_user.id)
      else
        object.hater_ids << current_user.id
      end
    end

    weight = delta * get_vote_weight_of_current_user
    object.votes += weight

    respond_to do |format|
      if object.save
        format.html {redirect_to :root }
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { redirect_to object }
        format.xml  { render :xml => object.errors, :status => :unprocessable_entity }
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

  def toggle_disabled
    item = get_item_based_on(params[:type], params[:id])
    item.disabled = !item.disabled
    item.save
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
end
