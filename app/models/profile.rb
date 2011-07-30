class Profile
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  #collections
  field :watched_tags, :type => Array, :default => []
  field :collected_tip_ids, :type => Array, :default => []

  #settings
  field :receive_mails, :type => Boolean, :default => true
  field :watched_distance, :type => Integer, :default => 2
  field :concern_days, :type => Integer, :default => 7
  field :last_updates_send_at, :type => DateTime
  mount_uploader :avatar, AvatarUploader

  field :show_watching_tags_panel, :type => Boolean, :default => true
  field :show_watching_locations_panel, :type => Boolean, :default => true
  field :show_collected_tips_panel, :type => Boolean, :default => true
  field :show_joined_groups_panel, :type => Boolean, :default => true

  attr_accessible :receive_mails, :watched_distance, :concern_days, :watched_locations_attributes, :avatar

  #relationships
  embedded_in :user
  embeds_many :watched_locations, :class_name => Location.name
  accepts_nested_attributes_for :watched_locations, :allow_destroy => true
  validates_associated :watched_locations
  validates_inclusion_of :watched_distance, :in => PROFILE_MIN_WATCHED_DISTANCE..PROFILE_MAX_WATCHED_DISTANCE
  validates_inclusion_of :concern_days, :in => PROFILE_MIN_CONCERN_DAYS..PROFILE_MAX_CONCERN_DAYS

  def watch_tags!(tags)
    if tags.present?
      tags = tags.split(",") if tags.is_a?(String)
      self.watched_tags ||= []
      self.watched_tags |= tags
      self.save!
    end
  end

  def collect_tip!(tip)
    if tip.present?
      self.collected_tip_ids ||= []
      self.collected_tip_ids << tip.id unless self.collected_tip_ids.include?(tip.id)
      self.save!
    end
  end

end