class InfoItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include AssociatedModels
  include Available
  include Locational

  field :title
  field :content
  field :reported_on, :type => DateTime

  #cached_values
  field :region_ids, :type => Array

  field :votes, :type => Integer, :default => 0
  field :fan_ids, :type => Array, :default => []
  field :hater_ids, :type => Array, :default => []

  index :reported_on

  attr_reader :region_tokens
  attr_accessible :title, :content, :reported_on_string, :images_attributes, :region_tokens

  #scopes
  scope :in_days_of, lambda { |days_in_number| where(:created_at.gt => days_in_number.days.ago) }
  scope :about, lambda{ |tag| any_in(:tags => [tag]) }
  #any_in will perform an intersaction when chained
  #TODO
  scope :of_type, lambda { |types| any_in(:_type => types ) }
  scope :bad, any_in(:_type => ["Review", "Article"])
  scope :good, any_in(:_type => ["Recommendation", "Tip"])
  scope :of_region, lambda { |region_id| any_in(:region_ids => [region_id])}
  scope :not_from_blocked_users, lambda { |blocked_user_ids| not_in(:author_id => blocked_user_ids) }

  #Relationships
  embeds_many :comments
  belongs_to :author, :class_name => "User"
  has_many :images

  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:image].blank? && i[:remote_image_url].blank? }, :allow_destroy => true

  validates_presence_of :title
  validates_length_of :title, :maximum => 30

  before_validation { errors.add(:reported_on, I18n.translate("validations.date.reported_on_invalid_msg")) if @reported_on_invalid }

  def reported_on_string
    self.reported_on ||= DateTime.now
    self.reported_on.strftime('%m/%d/%Y')
  end

  def reported_on_string=(reported_on_str)
    begin
      self.reported_on = DateTime.strptime(reported_on_str, '%m/%d/%Y')
    rescue
      @reported_on_invalid = true
    end
  end

  def region_tokens=(tokens)
    self.region_ids = tokens.split(',')
  end

  def is_recent?
    self.created_at >= GlobalConstants::ITEM_MEASURE_RECENT_DAYS.days.ago ? true : false
  end

  def is_popular?
    self.votes >= GlobalConstants::ITEM_MEASURE_POPULAR ? true : false
  end

end