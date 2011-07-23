class Profile
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  field :watched_foods, :type => Array, :default => []
  field :receive_mails, :type => Boolean, :default => true
  field :watched_distance, :type => Integer, :default => 2
  mount_uploader :avatar, AvatarUploader

  attr_accessible :receive_mails, :watched_distance, :watched_locations_attributes, :avatar

  #relationships
  embedded_in :user
  embeds_many :watched_locations, :class_name => Location.name
  accepts_nested_attributes_for :watched_locations, :allow_destroy => true

  validates_associated :watched_locations
  validates_inclusion_of :watched_distance, :in => PROFILE_MIN_WATCHED_DISTANCE..PROFILE_MAX_WATCHED_DISTANCE

  def add_foods(tags = [])
    for tag in tags
      self.watched_foods << tag unless self.watched_foods.include?(tag)
    end
  end

end