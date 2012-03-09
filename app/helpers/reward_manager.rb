class RewardManager
  def self.reward_for_like(item, user)
    if (item.respond_to? :author) && item.author
      score = 0
      if item.is_a?(Recipe)
        score = SCORE_LIKE_RECIPE
      elsif item.is_a?(Album)
        score = SCORE_LIKE_ALBUM
      end

      item.author.score += score
      item.author.save

      NotificationsManager.generate_for_item(item.author, user, item, "like", score)
    end
  end

  def self.reward_for_admire(item, user)
    if (item.respond_to? :author) && item.author
      item.author.score += SCORE_ADMIRE_DESIRE
      item.author.save
      NotificationsManager.generate_for_item(item.author, user, item, "admire", SCORE_ADMIRE_DESIRE)
    end
  end

  def self.reward_for_vote(vote, user)
    solution = vote.solution
    if solution.author
      solution.author.score += SCORE_VOTE_SOLUTION
      solution.author.save

      NotificationsManager.generate_for_item(solution.author, user, solution.desire, "vote", SCORE_VOTE_SOLUTION, vote.content)
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