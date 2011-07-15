class RewardManager
  def initialize(user)
    @user = user
  end

  def contribute(field)
    @user.contribution[field] += 1
    ask_for_badges
    #save user at last
    @user.save!
  end

  def ask_for_badges
    Badge.enabled.not_belong_to(@user).all.each do |badge|
      if badge.deserved_to?(@user)
        badge.rewarded_to!(@user)
      end
    end
  end

end