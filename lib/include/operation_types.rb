require "hash_enumeration"

class NotificationOperationTypes < HashEnumeration
  ["create_user"].each_with_index do |type, i|
    self.members[i] = type
  end
end