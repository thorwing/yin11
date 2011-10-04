class FeedsManager
  def self.push_feeds(item)
    if item.respond_to?(:enabled)
      return unless item.enabled
    end

    if item.respond_to?(:vendor) && item.vendor.present?
      item.vendor.feeds << Feed.new(:target_type => item.class.name, :target_id => item.id)
    end

     if item.respond_to?(:author) && item.author.present?
      item.author.feeds << Feed.new(:target_type => item.class.name, :target_id => item.id)
    end

    if item.respond_to?(:tags)  && item.tags.present?
      item.tags.each do |t|
        tag = Tag.find_or_initialize_by(:name => t)
        tag.feeds << Feed.new(:target_type => item.class.name, :target_id => item.id)
        tag.save!
      end
    end
  end

  def self.pull_feeds(user)
    items = []
    user.tags.each do |tag|
      tag.feeds.each {|f| items << f.get_item}
    end

    user.relationships.each do |r|
      followable = r.get_item
      feeds = followable.get_feeds
      feeds.each {|f| items << f.get_item} if feeds.present?
    end

    items.compact.uniq
  end
end