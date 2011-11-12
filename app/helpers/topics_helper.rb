module TopicsHelper
  def get_recommended_products(topic, limit = PRODUCTS_PER_TOPIC_LARGE)
    unless topic.tags.blank? || topic.tags.empty?
      Product.tagged_with(topic.tags).desc(:recommendation).limit(limit)
    else
      []
    end
  end

  def get_first_recommended_product(topic)
    unless topic.tags.blank? || topic.tags.empty?
      Product.tagged_with(topic.tags).desc(:recommendation).limit(1).first
    else
      nil
    end
  end

  def get_rest_recommended_product(topic)
    unless topic.tags.blank? || topic.tags.empty?
      Product.tagged_with(topic.tags).desc(:recommendation).skip(1).limit(PRODUCTS_PER_TOPIC_LARGE)
    else
      []
    end
  end

end
