module GroupsHelper
  def user_can_be_blocked?(user)
    return false unless current_user #guest can't block
    return false if current_user.id == user.id #user can't block himself
    return false if user.has_permission?(:editor) #user can't block editor or amdiun
    return false if (current_user.blocked_user_ids and current_user.blocked_user_ids.include?(user.id)) #already blocked!
    true
  end

  def user_can_be_unlocked?(user)
    if current_user and current_user.blocked_user_ids and current_user.blocked_user_ids.include?(user.id)
      true
    else
      false
    end
  end
end
