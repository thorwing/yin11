class NotificationsManager
  #def self.generate!(user_to_notify, person, operation = nil, item = nil, message = nil, score = nil)
  #  return false if user_to_notify == person
  #  user_to_notify.notifications.create! do |n|
  #    n.person_id = person.id if person
  #    n.item_id = item.id.to_s if item
  #    n.item_type = item.class.name if item
  #    n.operation = operation if operation
  #    n.message = message
  #    n.score = score if score
  #  end
  #end

  def self.generate_for_comment(user_to_notify, person, item, comment, has_parent = false)
    return if user_to_notify == person || person.nil? || item.nil?
    user_to_notify.notifications.create! do |n|
      n.category = "comment"
      n.person_id = person.id
      n.item_id = item.id.to_s
      n.item_type = item.class.name
      n.content = comment.content
      n.comment_id = comment.id.to_s
      n.has_parent = has_parent
    end
  end

  def self.generate_for_user(user_to_notify, person, status)
    return if user_to_notify == person || person.nil?
    user_to_notify.notifications.create! do |n|
      n.category = "user"
      n.person_id = person.id
      n.status = status
    end
  end

  def self.generate_for_relationship(user_to_notify, person, action)
      return if user_to_notify == person || person.nil?
      user_to_notify.notifications.create! do |n|
        n.category = "relationship"
        n.person_id = person.id
        n.action = action
      end
    end

  def self.generate_for_item(user_to_notify, person, item, action, score = 0, content = nil)
    return if user_to_notify == person || person.nil? || item.nil?
    user_to_notify.notifications.create! do |n|
      n.category = "item"
      n.person_id = person.id
      n.item_id = item.id.to_s
      n.item_type = item.class.name
      n.action = action
      n.score = score
      n.content = content
    end
  end


end