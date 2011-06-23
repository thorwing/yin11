class Article < InfoItem
  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :category, :default => ArticleTypes.get_values.first

  #Relationships
  embeds_one :source
  has_and_belongs_to_many :cities

  tokenize_many :cities

  accepts_nested_attributes_for :source, :reject_if => lambda { |s| s[:name].blank? }, :allow_destroy => true
  attr_accessible :category, :source_attributes

  validates_associated :source

  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :minimum => 10, :maximum => 10000, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
                                                                        :min => 10, :max => 10000)
  validates_inclusion_of :category, :in => ArticleTypes.get_values
end
