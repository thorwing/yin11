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
    if item.respond_to?(:author) && item.author
      #push feed to it's author
      new_feed = initialize_feed(item)
      item.author.feeds << new_feed
      item.author.save
    end
  end

  def self.pull_feeds(user)
    #key = 'feeds_for_' + user.id.to_s
    #feeds = Rails.cache.fetch(key)
    #if feeds.nil?
      raw_feeds = user.following_users.inject([]){|memo, user| memo | user.feeds} #.where(:created_at.lt => 1.weeks.ago)
      feeds = process(raw_feeds)

      #TODO
      #Rails.cache.write(key, feeds, :expires_in => 5.minutes)
    #end
    #different pagination of waterfall, it starts from 1
    feeds
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