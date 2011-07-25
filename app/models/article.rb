class Article < InfoItem
  #fields
  field :type

  #accessibles
  attr_accessible :type, :source_attributes

  #scopes
  scope :recommended, where(:recommended => true)

  #Relationships
  has_one :source

  accepts_nested_attributes_for :source, :reject_if => lambda { |s| s[:name].blank? }, :allow_destroy => true

  #validators
  validates_associated :source

  validates_presence_of :content
  validates_length_of :content, :maximum => 10000

  validates_inclusion_of :type, :in => ArticleTypes.get_values

  #callbacks
  before_validation {self.type ||= ArticleTypes.get_values.first}

  #methods
  def name_of_source
    self.source.name if source
  end

end
