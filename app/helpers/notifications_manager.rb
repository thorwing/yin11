class NotificationsManager
  def self.generate!(user_to_notify, person, operation = nil, item = nil, message = nil)
    return if user_to_notify == person
    user_to_notify.notifications.create! do |n|
      n.person_id = person.id if person
      n.item_id = item.id.to_s if item
      n.item_type = item.class.name if item
      n.operation = operation if operation
      n.message = message
    end
  end

end