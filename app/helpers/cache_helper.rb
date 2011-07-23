module CacheHelper
  def get_hot_tags
    tags = Rails.cache.read('hot_tags')
    if tags.blank?
      tags = InfoItem.tags_with_weight[0..CACHED_HOT_TAGS].map{ |e| e[0] }
      Rails.cache.write("hot_tags", tags)
    end
    tags
  end

  def get_all_tags
    tags = Rails.cache.read('all_tags')
    if tags.blank?
      tags = InfoItem.tags
      Rails.cache.write("all_tags", tags)
    end
    tags
  end

  def flush_cache
    Rails.cache.clear
  end
end