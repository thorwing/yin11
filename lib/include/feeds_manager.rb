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

    #TODO
    # decides using "product" or "products"
    products = []
    if item.respond_to?(:product) && item.product.present?
      products = [item.product]
    elsif item.respond_to?(:products) && item.products.present?
      products = item.products
    end

    products.each do |product|
      #feed is an embedded model, create a new feed everytime
      product.feeds << initialize_feed(item)
      product.save!

      #push feed to it's vendor'
      product.vendor.feeds << initialize_feed(item)
      product.vendor.save!

      product.tags.each do |t|
        tag = Tag.find_or_initialize_by(:name => t)
        tag.feeds << initialize_feed(item)
        tag.save!
      end
    end

    #push feed to it's author
    if item.respond_to?(:author) && item.author.present?
      new_feed = initialize_feed(item)
      item.author.feeds << new_feed
      item.author.save!
    end

    #push feed to all tags it contains
    if item.respond_to?(:tags)  && item.tags.present?
      item.tags.each do |t|
        tag = Tag.find_or_initialize_by(:name => t)
        tag.feeds << initialize_feed(item)
        tag.save!
      end
    end
  end

  def self.pull_feeds(user, page, per)
    feeds = user.tags.inject([]) do  |memo, t|
      tag = Tag.find(t)
      memo | tag.feeds
    end

    user.relationships.each do |r|
      followable = r.get_item
      feeds += followable.feeds
    end

    feeds = process_feeds(feeds)
    return feeds[(page * per)..((page + 1)* per)], feeds.size
  end

  def self.get_tagged_feeds(tags, page, per)
    feeds = tags.inject([]) do  |memo, tag|
      memo | tag.feeds
    end

    feeds = process_feeds(feeds)
    return feeds[(page * per)..((page + 1)* per)], feeds.size
  end

  def self.get_feeds_of(user)
    feeds = process_feeds(user.feeds)
  end

  private
  def self.process_feeds(feeds)
    feeds.reject{|f| f.cracked?}.sort{|x, y| y.created_at <=> x.created_at}.compact.uniq {|f| f.identity }
  end

end