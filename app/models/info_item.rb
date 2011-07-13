class InfoItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include AssociatedModels
  include Available
  include Locational

  scope :in_days_of, lambda { |days_in_number| where(:created_at.gt => days_in_number.days.ago) }
  scope :about, lambda{ |tag| any_in(:tags => [tag]) }
  scope :bad, any_in(:_type => ["Review", "Article"])
  scope :good, any_in(:_type => ["Recommendation", "Tip"])
  scope :of_region, lambda { |region_id| any_in(:region_ids => [region_id])}
  scope :not_from_blocked_users, lambda { |blocked_user_ids| not_in(:author_id => blocked_user_ids) }

  field :title, :type => String
  field :content, :type => String
  field :reported_on, :type => DateTime

  #cached_values
  field :region_ids, :type => Array

  field :votes, :type => Integer, :default => 0
  field :fan_ids, :type => Array, :default => []
  field :hater_ids, :type => Array, :default => []

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

  attr_reader :region_tokens
  def region_tokens=(tokens)
    self.region_ids = tokens.split(',')
  end

  #Relationships
  embeds_many :comments
  has_many :images
  belongs_to :author, :class_name => "User"

  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:image].blank? && i[:remote_image_url].blank? }, :allow_destroy => true

  attr_accessible :title, :content, :reported_on_string, :images_attributes, :region_tokens

  validates_presence_of :title, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.title") )
  validates_length_of :title, :maximum => 30, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.title"),
                                                          :max => 30)
  #TODO
  #validates_presence_of :images

  before_validation :check_date

  def is_recent?
    self.created_at >= GlobalConstants::ITEM_MEASURE_RECENT_DAYS.days.ago ? true : false
  end

  def is_popular?
    self.votes >= GlobalConstants::ITEM_MEASURE_POPULAR ? true : false
  end

  protected
  def check_date
     errors.add(:reported_on, I18n.translate("validations.date.reported_on_invalid_msg")) if @reported_on_invalid
  end

end