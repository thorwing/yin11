class Profile
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  #collections
  field :collected_tip_ids, :type => Array, :default => []

  #settings
  field :receive_mails, :type => Boolean, :default => true
  field :watched_distance, :type => Integer, :default => 2
  field :concern_days, :type => Integer, :default => 7
  field :last_updates_send_at, :type => DateTime

  field :show_watching_tags_panel, :type => Boolean, :default => true
  field :show_watching_locations_panel, :type => Boolean, :default => true
  field :show_collected_tips_panel, :type => Boolean, :default => true
  field :show_joined_groups_panel, :type => Boolean, :default => true

  attr_accessible :receive_mails, :watched_distance, :concern_days, :watched_locations_attributes

  #relationships
  embedded_in :user
  embeds_many :watched_locations, :class_name => Location.name
  accepts_nested_attributes_for :watched_locations, :allow_destroy => true
  validates_associated :watched_locations
  validates_inclusion_of :watched_distance, :in => PROFILE_MIN_WATCHED_DISTANCE..PROFILE_MAX_WATCHED_DISTANCE
  validates_inclusion_of :concern_days, :in => PROFILE_MIN_CONCERN_DAYS..PROFILE_MAX_CONCERN_DAYS

  def collect_tip!(tip)
    if tip.present?
      self.collected_tip_ids ||= []
      self.collected_tip_ids << tip.id unless self.collected_tip_ids.include?(tip.id)
      self.save!
    end
  end

  #for multilstep form
  attr_writer :current_step

  def steps
    %w[custom_groups custom_basic_info custom_preferences]
  end

  def current_step
	  @current_step || steps.first
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

end