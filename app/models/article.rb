class Article
  include Mongoid::Document
  include AssociatedModels
  include Available
  include Informative

  default_scope where(:disabled => false )
  scope :in_days_of, ->(days_in_number) {where(:created_at.gt => days_in_number.days.ago )}
  scope :about, ->(food) {any_in(food_ids: [food.is_a?(Food) ? food.id : food])}
  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :published_on, :type => DateTime
  field :category

  def published_on_string
    published_on ||= DateTime.now
    published_on.strftime('%m/%d/%Y')
  end

  def published_on_string=(published_on_str)
    self.published_on = DateTime.parse(published_on_str)
  rescue ArgumentError
    @published_on_invalid = true
  end

  def validate
    errors.add(:published_on, "is invalid") if @published_on_invalid
  end

  #Relationships
  belongs_to :vendor
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :foods
  tokenize_many :cities, :foods
  tokenize_one :vendor
  embeds_one :source

  accepts_nested_attributes_for :source, :reject_if => lambda { |s| s[:name].blank? && s[:site].blank? }, :allow_destroy => true
  attr_accessible :published_on_string, :category, :source_attributes

  validates_associated :source

  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :minimum => 10, :maximum => 10000, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
                                                                        :min => 10, :max => 10000)
  validates_inclusion_of :category, :in => ["case", "knowledge"]
end
