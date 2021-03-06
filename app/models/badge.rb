class Badge
  include Mongoid::Document
  include Mongoid::Timestamps
  include Available

  field :name
  field :description

  field :contribution_field
  field :comparator
  field :compared_value, :type => Integer
  #mount_uploader :icon, IconUploader

  attr_accessible :name, :description, :contribution_field, :comparator, :compared_value, :enabled, :icon

  scope :not_belong_to, lambda { |user| not_in(:_id => user.badge_ids) }

  #relationships
  has_and_belongs_to_many :users

  #validators
  validates_uniqueness_of :name
  validates_presence_of :name, :contribution_field, :comparator, :compared_value

  COMPARATOR_HASH = {
    :equals => "==",
    :not_equals => "!=",
    :less_than => "<",
    :less_than_or_equals => "<=",
    :greater_than => ">",
    :greater_than_or_equals => ">="
  }

  def deserved_to?(user)
    eval "user.contribution.try(:#{self.contribution_field})#{self.comparator}#{self.compared_value}"
  end

  def rewarded_to!(user)
    self.user_ids << user.id
    self.save!

    user.badge_ids << self.id
  end

  def get_icon
    if self.icon?
      logger = Logger.new(STDOUT)
      logger.info self.icon.url.to_s
      self.icon.url
    else
      "badge.png"
    end
  end

end
