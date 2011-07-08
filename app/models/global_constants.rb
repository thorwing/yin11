module GlobalConstants
  # also notice the call to 'freeze'
  #default
  ITEMS_PER_PAGE_FEW = 5.freeze
  ITEMS_PER_PAGE_MANY = 20.freeze
  ITEMS_PER_PAGE_POPULAR = 10.freeze
  ITEMS_PER_PAGE_RECENT = 10.freeze
  ITEMS_PER_PAGE_HOT = 10.freeze
  ITEMS_PER_PAGE_GROUP = 10.freeze
  ITEMS_EFFECTIVE_DAYS = 14.freeze
  TAG_CLOUD_COUNT = 50.freeze
  CACHED_HOT_TAGS = 30.freeze
  MAX_TAGS = 5.freeze
  HOT_ARTICLES_ON_HOME_PAGE = 10.freeze
  NORMAL_USER_ROLE = 1.freeze
  AUTHORIZED_USER_ROLE = 3.freeze
  EDITOR_ROLE = 7.freeze
  ADMIN_ROLE = 9.freeze
  VENDOR_RECENT_REVIEWS = 3.freeze
  TIME_FORMAT = '%m/%d/%Y'.freeze
  ITEM_MEASURE_RECENT_DAYS = 3.freeze
  ITEM_MEASURE_POPULAR = 20.freeze
end
