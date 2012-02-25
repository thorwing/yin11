class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  #when , who, did what
  field :person_id
  field :item_type
  field :item_id
  field :operation
  field :message
  field :read, :type => Boolean, :default => false
  field :score, :type => Integer, :default => 0

  #relationships
  embedded_in :user

  #validations
  def self.operations
    ["comment", "like", "admire", "recommend", "edit", "delete", "follow", "become_master", "add_review", "solve", "vote", nil]
  end
  validates_inclusion_of :operation, :in => Notification.operations

  def self.item_types
    ["Review", "Recipe", "Album", "Comment", "Desire", nil]
  end
  validates_inclusion_of :item_type, :in => Notification.item_types

  def person
    @person ||= User.first(conditions: {id: self.person_id})
    @person
  end

  def item
    if @item
      @item
    elsif self.item_id.present? && self.item_type.present?
      @item = eval("#{self.item_type}.first(conditions: {id: '#{self.item_id.to_s}'})")
      @item
    else
      nil
    end
  end

  def subject
    subject = ''
    if self.item_id.present? && self.item_type.present? && self.operation.present? && self.person_id.present?
      if self.item && self.person
        #item notification
        item_str = I18n.t("notifications.item_types.#{self.item_type}")
        operation_str = I18n.t("notifications.operations.#{self.operation}")
        person_str = self.person.login_name
        subject = I18n.t("notifications.item_notification", person_str: person_str, operation_str: operation_str, item_str: item_str)
        subject += I18n.t("notifications.reward_notification", count: self.score) if (self.score && self.score > 0)
      end
    end

    if self.operation == "vote"
      subject = I18n.t("notifications.vote_notification", person_str: person_str) + I18n.t("notifications.reward_notification", count: self.score) if (self.score && self.score > 0)
    end

    if self.operation == "become_master"
      subject = I18n.t("notifications.master_notification")
    end

    if self.operation == "follow"
      person = User.first(conditions: {id: self.person_id})
      person_str = person.login_name
      operation_str = I18n.t("notifications.operations.#{self.operation}")
      subject = I18n.t("notifications.me_notification", person_str: person_str, operation_str: operation_str)
    end

    (subject || notification.message) || ''
  end

  #used for uniq()
  def identity
    [self.created_at.strftime("%y-%m-%d"), self.person_id, self.item_type, self.item_id, self.operation]
  end

end