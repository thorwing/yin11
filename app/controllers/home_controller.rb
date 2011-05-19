class HomeController < ApplicationController

  def index
    if current_user && current_user.profile.cared_foods.size > 0
      @interested_info = {}
      for id in current_user.profile.cared_foods do
        food = Food.find(id)
        food_info = []
        food_info = get_related_reviews_of(food).inject([]){ |info_array, review| info_array << review } if current_user.profile.display_reviews
        #TODO
       # raise get_related_articles_of(food, current_user).size.to_s
        food_info += get_related_articles_of(food, current_user).inject([]){ |info_array, article| info_array << article } if current_user.profile.display_articles
        @interested_info[food.name] = food_info.sort{ |a, b| (a.is_a?(Article) ? 1 : a.votes) <=> (b.is_a?(Article) ? 1 : b.votes)}.reverse()[0..2]
      end
    else
      @recent_info = []
      @recent_info = Review.desc(:updated_at)[0..9] + Article.desc(:updated_at)[0..9]
      @recent_info = @recent_info.sort!{ |a, b| a.votes <=> b.votes}.reverse()[0..4]
    end
  end

end
