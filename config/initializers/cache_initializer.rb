#intializer the cache
def fill_hot_tags
  tag_names = InfoItem.tags_with_weight[0..GlobalConstants::CACHED_HOT_TAGS].map{ |e| e[0] }
  Rails.cache.write("hot_tags", tag_names)
end