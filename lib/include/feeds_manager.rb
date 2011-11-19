class FeedsManager
  def initialize_feed(item)
    Feed.new(:target_type => item.class.name, :target_id => item.id)
  end

  def self.push_feeds(item)
    if item.respond_to?(:enabled)
      return nil unless item.enabled
    end

    feed = initialize_feed(item)
    #push feed to it's vendor'
    if item.respond_to?(:vendor) && item.vendor.present?
      item.vendor.feeds << feed
      item.vendor.save!
    end

    #push feed to it's author
    if item.respond_to?(:author) && item.author.present?
      item.author.feeds << feed
      item.author.save!
    end

    #push feed to all tags it contains
    if item.respond_to?(:tags)  && item.tags.present?
      item.tags.each do |t|
        tag = Tag.find_or_initialize_by(:name => t)
        tag.feeds << feed
        tag.save!
      end
    end

    feed
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