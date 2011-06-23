class HomeController < ApplicationController

  def index
    if current_user && current_user.profile.watching_foods.size > 0
      #TODO
      @watching_foods = Food.any_in(name: current_user.profile.watching_foods)
    end

    @reviews = Review.desc(:updated_at).page(1).per(2)
    @hot_articles = Article.enabled.desc(:updated_at).limit(6)

    #TODO
    @foods_buzz = Food.desc([:review_ids, :article_ids]).limit(5).group_by{ |f| f.categories[0] }
  end

  def reviews
    @reviews = Review.desc(:updated_at).page(params[:page]).per(2)
    respond_to do |format|
      format.html {render :reviews, :layout => false}
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
    object = get_item_based_on(params[:type], params[:id])

    delta = params[:delta].to_i

    first_vote = false

    if delta > 0
      if object.fan_ids.include?(current_user.id)
        delta *= -1
        object.fan_ids.delete(current_user.id)
      elsif object.hater_ids.include?(current_user.id)
        object.hater_ids.delete(current_user.id)
      else
        object.fan_ids << current_user.id
        first_vote = true
      end
    else
      if object.hater_ids.include?(current_user.id)
        delta *= -1
        object.hater_ids.delete(current_user.id)
      elsif object.fan_ids.include?(current_user.id)
        object.fan_ids.delete(current_user.id)
      else
        object.hater_ids << current_user.id
        first_vote = true
      end
    end

    weight = delta * get_vote_weight_of_current_user
    object.votes += weight

    current_user.make_contribution(:total_up_votes, 1) if first_vote && weight > 0
    current_user.make_contribution(:total_down_votes, 1) if first_vote && weight < 0

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
      result = Review.desc(:updated_at).page(page).per(per/2) + Article.enabled.desc(:updated_at).per(per/2)
      result = result.sort!{ |a, b| a.votes <=> b.votes}.reverse()[0..4]
    end
    result
  end
end
