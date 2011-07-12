class Profile
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  #food names
  field :watched_foods, :type => Array, :default => []
  field :receive_mails, :type => Boolean, :default => true
  field :watched_distance, :type => Integer, :default => 2

  mount_uploader :avatar, AvatarUploader

  #relationships
  embedded_in :user
  embeds_many :watched_locations, :class_name => Location.name

  accepts_nested_attributes_for :watched_locations, :allow_destroy => true
  attr_accessible :receive_mails, :watched_locations_attributes, :watched_distance, :avatar
  validates_inclusion_of :watched_distance, :in => GlobalConstants::PROFILE_MIN_WATCHED_DISTANCE..GlobalConstants::PROFILE_MAX_WATCHED_DISTANCE
  validates_associated :watched_locations

  def add_foods(tags = [])
    for tag in tags
      self.watched_foods << tag unless self.watched_foods.include?(tag)
    end
  end

end