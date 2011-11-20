class CacheManager
  #def self.hot_tags
  #  hot_tags_with_weight.map{|e| e[0]}
  #end
  #
  #def self.hot_tags_with_weight
  #  #TODO
  #  tags = nil # Rails.cache.read('hot_tags')
  #  if tags.blank?
  #    tags = InfoItem.enabled.tags_with_weight[0..TAG_CLOUD_COUNT]
  #    Rails.cache.write("hot_tags", tags)
  #  end
  #  tags
  #end
  #
  #def self.all_tags
  #  all_tags_with_weight.map{|e| e[0]}
  #end
  #
  #def self.all_tags_with_weight
  #   #TODO
  #  tags = nil # Rails.cache.read('all_tags')
  #  if tags.blank?
  #    tags = InfoItem.enabled.tags_with_weight
  #    Rails.cache.write("all_tags", tags)
  #  end
  #  tags
  #end
  #
  #def self.flush_cache
  #  Rails.cache.clear
  #end
end