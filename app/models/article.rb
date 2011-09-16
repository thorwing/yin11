class Article < InfoItem
  #fields
  field :type
  field :introduction
  field :region_ids, :type => Array

  #accessibles
  attr_reader :region_tokens
  attr_accessible :type, :source_attributes, :region_tokens, :introduction

  #scopes
  scope :recommended, where(:recommended => true)
  scope :news, where(:type => "news")
  scope :topics, where(:type => "topic")
  scope :tips, where(:type => "tip")
  #scope :of_region, lambda { |region_id| any_in(:region_ids => [region_id])}

  #Relationships
  embeds_one :source

  accepts_nested_attributes_for :source, :reject_if => lambda { |s| s[:name].blank? }, :allow_destroy => true

  #validators
  validates_associated :source

  validates_presence_of :content
  validates_length_of :content, :maximum => 10000
  validates_length_of :introduction, :maximum => 300

  validates_inclusion_of :type, :in => ArticleTypes.get_values

  #callbacks
  before_validation {
    self.type ||= ArticleTypes.get_values.first
    self.positive = (self.type == ArticleTypes.get_values.last)
    true
  }

  #methods
  def name_of_source
    self.source.name if source
  end

  def region_tokens=(tokens)
    self.region_ids = tokens.split(',')
    #TODO
    region = ItemFinder.get_region(self.region_ids.first)
    self.city ||= region.name if region
  end

end
