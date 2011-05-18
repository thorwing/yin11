class HomeController < ApplicationController

  def index
    @interested_info = {}

    if current_user && current_user.profile.cared_foods.size > 0


      for id in current_user.profile.cared_foods do
        food = Food.find(id)
        food_info = get_related_reviews_of(food).inject([]){ |info_array, review| info_array << review }
        #TODO
       # raise get_related_articles_of(food, current_user).size.to_s
        food_info += get_related_articles_of(food, current_user).inject([]){ |info_array, article| info_array << article }
        @interested_info[food.name] = food_info.sort{ |a, b| (a.is_a?(Article) ? 1 : a.votes) <=> (b.is_a?(Article) ? 1 : b.votes)}.reverse()[0..2]
      end
    end

    @recent_reviews = Review.desc(:updated_at)
    @recent_articles = Article.desc(:updated_at)
  end

end
