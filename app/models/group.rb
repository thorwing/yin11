class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Followable

  field :name
  field :description

  #cached_fields
  field :creator_id

  attr_accessible :name, :description

  #relationships
  has_and_belongs_to_many :members, :class_name => User.name
  has_many :posts
  embeds_many :feeds

  #validators
  validates_presence_of :name, :creator_id
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 30
  validates_length_of :description, :maximum => 200

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