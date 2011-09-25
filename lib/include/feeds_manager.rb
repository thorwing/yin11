class FeedsManager
  def self.push_feeds(followable, item)
    followable.followers.each do |user_id|
      user = User.find(user_id)
      if user.has_permission?(:normal_user)
        user.feeds <<  Feed.new(:target_type => item.class.name, :target_id => item.id)
      end
    end
  end
end