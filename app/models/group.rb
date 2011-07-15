class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Locational

  field :name
  field :description

  #cached_fields
  field :creator_id

  #relationships
  has_and_belongs_to_many :members, :class_name => User.name
  has_many :posts

  attr_accessible :name, :description

  #validators
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.name"),
                                                                           :max => 20)
  validates_length_of :description, :maximum => 200, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.description"),
                                                                           :max => 200)

  def is_creator_by?(user)
    (user and user.id == self.creator_id) ? true : false
  end

  def join!(user)
    self.member_ids << user.id
    self.save!

    user.group_ids << self.id
    user.save!
  end

  def quit!(user)
    self.member_ids.delete(user.id)
    self.save!

    user.group_ids.delete(self.id)
    user.save!
  end

end