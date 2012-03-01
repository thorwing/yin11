class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  #when , who, did what
  field :category
  field :person_id
  field :item_type
  field :item_id
  field :action
  field :status
  field :comment_id
  field :has_parent
  field :content
  field :read, :type => Boolean, :default => false
  field :score, :type => Integer, :default => 0

  #relationships
  embedded_in :user

  #validations
  validates_inclusion_of :category, :in => ["relationship", "user", "item", "comment"]

  validates_inclusion_of :item_type, :in => ["Solution", "Recipe", "Album", "Desire", nil]

  validates_inclusion_of :action, :in => ["delete", "like", "vote", "admire", "solve", "follow", nil]

  validates_inclusion_of :status, :in => ["master", "group_admin", nil]

  def person
    if self.person_id.present?
      @person ||= User.first(conditions: {id: self.person_id})
      @person
    else
      nil
    end
  end

  def item
    if self.item_id.present? && self.item_type.present?
      @item ||= eval("#{self.item_type}.first(conditions: {id: '#{self.item_id.to_s}'})")
      @item
    else
      nil
    end
  end

  def subject
    subject = ''
    item_type_str = self.item_type.present? ? I18n.t("notifications.item_types.#{self.item_type}") : ""
    action_str = self.action.present? ? I18n.t("notifications.actions.#{self.action}") : ""
    person_str = self.person.present? ? self.person.login_name : ""
    case category
      when "relationship"
        if self.action == "follow"
          subject = I18n.t("notifications.follow_notification", person_str: person_str)
        end
      when "user"
        if self.status == "master"
          subject = I18n.t("notifications.master_notification")
        end
      when "item"
        if self.item_id.present? && self.item_type.present? && self.action.present? && self.person_id.present?
          #item notification
          if action == "solve"
            subject = I18n.t("notifications.solve_notification", person_str: person_str)
          elsif action == "vote"
            subject = I18n.t("notifications.vote_notification", person_str: person_str)
          else
            subject = I18n.t("notifications.item_notification", person_str: person_str, action_str: action_str, item_type_str: item_type_str)
          end
        end
      when "comment"
        if has_parent
          subject = I18n.t("notifications.reply_comment_notifiction", person_str: person_str, item_type_str: item_type_str)
        else
          subject = I18n.t("notifications.comment_notifiction", person_str: person_str, item_type_str: item_type_str)
        end
    end

    subject
  end

  def side_notification
    subject = ''
    if (self.score && self.score > 0)
      subject = I18n.t("notifications.reward_notification", count: self.score)
    end
    subject
  end

  #used for uniq()
  #def identity
  #  [self.created_at.strftime("%y-%m-%d"), self.person_id, self.item_type, self.item_id, self.action]
  #end

end