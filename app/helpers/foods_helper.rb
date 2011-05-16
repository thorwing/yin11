module FoodsHelper

  FOOD_ARTICLES_LIMIT = 5

  #TODO
  def get_related_reviews_of(food)
    related_reviews =  Review.where(food_id: food.id)
    related_reviews
  end

  def get_related_articles_of(food, user = nil)
    result = []
    result = Article.in_days_of(7).about(food).in_city(user.address.city_id).desc(:created_at).limit(FOOD_ARTICLES_LIMIT) if user


    if result.size < FOOD_ARTICLES_LIMIT
      result = result | Article.in_days_of(14).about(food).desc(:created_at)
    end

    result.size > FOOD_ARTICLES_LIMIT ? result[0...FOOD_ARTICLES_LIMIT - 1] : result
  end

  def get_conflicts_of(foods)
    result = []
    return result if foods.size < 2

    food_names = foods.collect{|f| f.name }

    food_names.each do |food_name|
      page = Wiki.load_page(food_name)

      if page
#        m = page.content =~ /<h2\s[^>]*conflict_sec[^>]*>(.*?)<\/h2>(.*)(<h2>|\z)/
        match = page.content.match(/<h2\s[^>]*conflict_sec[^>]*>(.*?)<\/h2>(.*)(<h2>|\z)/m)
        if match
          #match[0] is the whole mathc itself
          section_header = match[1]
          section_content = match[2]

          section_content.scan(/<li>([^:]+)[:]\s*(.*?)<\/li>/m) { |conflict|
            conflicted_food_name = conflict[0]
            detail = conflict[1]
            result << { :food1 => food_name, :food2 => conflicted_food_name, :detail => detail } if food_names.include?(conflicted_food_name)
          }
        end
      end
    end

    result
  end
end
