module TopicsHelper
  def get_recommended_products(topic, limit = PRODUCTS_PER_TOPIC_LARGE)
    unless topic.tags.blank? || topic.tags.empty?
      Product.tagged_with(topic.tags).asc(:priority).limit(limit)
    else
      []
    end
  end

  def get_first_recommended_product(topic)
    unless topic.tags.blank? || topic.tags.empty?
      Product.tagged_with(topic.tags).asc(:priority).limit(1).first
    else
      nil
    end
  end

  def get_rest_recommended_product(topic)
    unless topic.tags.blank? || topic.tags.empty?
      Product.tagged_with(topic.tags).asc(:priority).skip(1).limit(PRODUCTS_PER_TOPIC_LARGE)
    else
      []
    end
  end

  def get_first_recipes(topic)
    unless topic.tags.blank? || topic.tags.empty?
      Article.recipes.enabled.tagged_with(topic.tags).limit(1)
    else
      nil
    end
  end

  def get_recipes(topic)
    unless topic.tags.blank? || topic.tags.empty?
      Article.recipes.enabled.tagged_with(topic.tags)
    else
      []
    end
  end

  def get_reviews(topic)
    unless topic.tags.blank? || topic.tags.empty?
      products = Product.tagged_with(topic.tags)
      reviews = products.inject([]){|memo, p| memo << p.reviews}.uniq
      reviews
    else
      []
    end
  end
end
