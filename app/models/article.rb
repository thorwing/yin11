class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include AssociatedModels
  include Available
  include Votable
  include Imageable
  include Feedable
  include SilverSphinxModel

  #fields
  field :title
  field :content
  field :reported_on, :type => DateTime
  field :type
  field :introduction
  field :region_ids, :type => Array

  index :title

  search_index(:fields => [:title, :content],
              :attributes => [:created_at, :updated_at])

  #accessibles
  attr_reader :region_tokens
  attr_accessible :title, :content, :reported_on_string, :images_attributes, :type, :source_attributes, :region_tokens, :introduction, :author_id

  #scopes
  scope :in_days_of, lambda { |days_in_number| where(:created_at.gt => days_in_number.days.ago) }
  scope :about, lambda{ |tag| any_in(:tags => [tag]) }
  scope :recommended, where(:recommended => true)
  scope :themes, where(:type => 'theme')
  scope :news, where(:type => 'news')
  scope :tips, where(:type => 'tip')
  scope :recipes, where(:type => 'recipe')

  #Relationships
  embeds_many :comments
  belongs_to :author, :class_name => "User"
  has_many :images
  embeds_one :source
  belongs_to :topic

  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:image].blank? && i[:remote_picture_url].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :source, :reject_if => lambda { |s| s[:name].blank? }, :allow_destroy => true

  #validators
  validates_associated :source

  validates_presence_of :title
  validates_length_of :title, :maximum => 30
  validates_presence_of :content
  validates_length_of :content, :maximum => 10000
  validates_length_of :introduction, :maximum => 300
  validates_presence_of :type

  def self.types
    ['theme', 'news', 'tip', "recipe"]
  end

  validates_inclusion_of :type, :in => Article.types

  before_validation { errors.add(:reported_on, I18n.translate("validations.date.reported_on_invalid_msg")) if @reported_on_invalid }

  #methods
  def name_of_source
    self.source.name if source
  end

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

  def is_recent?
    self.created_at >= ITEM_MEASURE_RECENT_DAYS.days.ago ? true : false
  end

  def is_popular?
    self.votes >= ITEM_MEASURE_POPULAR ? true : false
  end

end
