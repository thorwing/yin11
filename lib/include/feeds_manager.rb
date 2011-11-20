class FeedsManager

  def self.initialize_feed(item)
    if item.new_record?
      operation = "create"
    elsif
      operation = "update"
    end
    Feed.new(:target_type => item.class.name, :target_id => item.id, :target_operation => operation)
  end

  def self.push_feeds(item)
    #if item.respond_to?(:enabled)
    #  return nil unless item.enabled
    #end

    #feed is an embedded model
    if item.respond_to?(:product) && item.product.present?
      item.product.feeds << initialize_feed(item)
      item.product.save!

      #push feed to it's vendor'
      item.product.vendor.feeds << initialize_feed(item)
      item.product.vendor.save!

      item.product.tags.each do |t|
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

  def self.pull_feeds(user)
    feeds = user.tags.inject([]){ |memo, tag| memo | tag.feeds }

    user.relationships.each do |r|
      followable = r.get_item
      feeds |= followable.feeds
    end

    feeds.compact.uniq
  end
end