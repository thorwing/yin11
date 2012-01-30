class RewardManager
  def self.reward_for_like(item, user = nil)
    if (item.respond_to? :author) && item.author
      score_value = 5
      item.author.score += score_value
      item.author.save

      NotificationsManager.generate!(item.author, user, "like", item, nil, score_value)
    end
  end

  def self.reward_for_admire(item, user = nil)
    if (item.respond_to? :author) && item.author
      score_value = 5
      item.author.score += score_value
      item.author.save

      NotificationsManager.generate!(item.author, user, "admire", item, nil, score_value)
    end
  end

  def ask_for_badges
    Badge.enabled.not_belong_to(@user).all.each do |badge|
      if badge.deserved_to?(@user)
        badge.rewarded_to!(@user)
      end
    end
  end

end