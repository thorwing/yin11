class Article < InfoItem
  include SilverSphinxModel

  #fields
  field :type
  field :introduction
  field :region_ids, :type => Array

  search_index(:fields => [:title, :content],
              :attributes => [:created_at, :updated_at])

  #accessibles
  attr_reader :region_tokens
  attr_accessible :type, :source_attributes, :region_tokens, :introduction, :author_id

  #scopes
  scope :recommended, where(:recommended => true)
  scope :news, where(:type => I18n.t("article_types.news"))
  scope :topics, where(:type => I18n.t("article_types.topic"))
  scope :tips, where(:type => I18n.t("article_types.tip"))
  #scope :of_region, lambda { |region_id| any_in(:region_ids => [region_id])}

  #Relationships
  embeds_one :source

  accepts_nested_attributes_for :source, :reject_if => lambda { |s| s[:name].blank? }, :allow_destroy => true

  #validators
  validates_associated :source

  validates_presence_of :content
  validates_length_of :content, :maximum => 10000
  validates_length_of :introduction, :maximum => 300
  validates_presence_of :type

  def self.types
    [I18n.t("article_types.topic"), I18n.t("article_types.news"), I18n.t("article_types.tip")]
  end
  validates_inclusion_of :type, :in => Article.types

  #methods
  def name_of_source
    self.source.name if source
  end

  #def region_tokens=(tokens)
  #  self.region_ids = tokens.split(',')
  #  region = ItemFinder.get_region(self.region_ids.first)
  #  self.city ||= region.name if region
  #end

end
