module TopicsHelper
  def get_recommended_products(topic, limit = PRODUCTS_PER_TOPIC_LARGE)
    unless topic.tags.blank? || topic.tags.empty?
      Product.tagged_with(topic.tags).desc(:recommendation).limit(limit)
    else
      []
    end
  end
end
