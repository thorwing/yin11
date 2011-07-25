module TipsHelper
  def is_already_collected(tip)
    if current_user && current_user.profile.collected_tip_ids && current_user.profile.collected_tip_ids.include?(tip.id)
      true
    else
      false
    end
  end
end