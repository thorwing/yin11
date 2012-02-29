class FeedsManager

  def self.initialize_feed(item)
    if item.new_record?
      operation = "create"
    else
      operation = "update"
    end
    Feed.new(:target_type => item.class.name, :target_id => item.id, :target_operation => operation)
  end

  def self.push_feeds(item)
    #if item.respond_to?(:enabled)
    #  return nil unless item.enabled
    #end
    #if item.respond_to?(:products) && item.products
    #  item.products.each do |product|
    #    #feed is an embedded model, create a new feed everytime
    #    product.feeds << initialize_feed(item)
    #    product.save!
    #
    #    #push feed to it's vendor'
    #    product.vendor.feeds << initialize_feed(item)
    #    product.vendor.save!
    #
    #    product.tags.each do |t|
    #      tag = Tag.find_or_initialize_by(:name => t)
    #      tag.feeds << initialize_feed(item)
    #      tag.save!
    #    end
    #  end
    #end
    #
    #if item.respond_to?(:recipes) && item.recipes
    #  item.recipes.each do |recipe|
    #    #feed is an embedded model, create a new feed everytime
    #    recipe.feeds << initialize_feed(item)
    #    recipe.save!
    #
    #    recipe.tags.each do |t|
    #      tag = Tag.find_or_initialize_by(:name => t)
    #      tag.feeds << initialize_feed(item)
    #      tag.save!
    #    end
    #  end
    #end

    if item.respond_to?(:author) && item.author
      #push feed to it's author
      new_feed = initialize_feed(item)
      item.author.feeds << new_feed
      item.author.save
    end

    if item.respond_to?(:tags) && item.tags
      #push feed to all tags it contains
      item.tags.each do |t|
        tag = Tag.find_or_initialize_by(:name => t)
        tag.feeds << initialize_feed(item)
        tag.save
      end
    end
  end

  def self.pull_feeds(user)
    key = 'feeds_for_' + user.id.to_s
    feeds = Rails.cache.fetch(key)
    if feeds.nil?
      followed_user_ids = user.relationships.select{|r| r.target_type == "User"}.map(&:target_id)
      users = User.any_in(_id: followed_user_ids)
      raw_feeds = users.inject([]){|memo, user| memo | user.feeds} #.where(:created_at.lt => 1.weeks.ago)
      feeds = process(raw_feeds)

      #Rails.cache.write(key, feeds, :expires_in => 5.minutes)
    end
    #different pagination of waterfall, it starts from 1
    return feeds
  end

  def self.get_tagged_feeds(tags)
    feeds = tags.inject([]) do  |memo, tag|
      memo | tag.feeds
    end

    feeds = process(feeds)
    return feeds, feeds.size
  end

  def self.get_feeds_of(user)
    feeds = process(user.feeds)
  end

  private
  def self.process(feeds)
    feeds.compact.uniq{|f| f.identity}.reject{|f| f.created_at.blank?}.sort{|x, y| y.created_at <=> x.created_at}
  end

end