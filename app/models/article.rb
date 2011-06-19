class Article
  include Mongoid::Document
  include AssociatedModels
  include Available
  include Informative

  default_scope where(:authorized => true )
  scope :in_days_of, ->(days_in_number) {where(:created_at.gt => days_in_number.days.ago )}
  scope :about, ->(food) {any_in(food_ids: [food.is_a?(Food) ? food.id : food])}
  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :source
  field :published_on, :type => DateTime
  field :authorized, :type => Boolean, :default => false
  field :category

  #Relationships
  belongs_to :vendor
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :foods
  tokenize_many :cities, :foods
  tokenize_one :vendor

  attr_accessible :source, :published_on, :category, :authorized

  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :minimum => 10, :maximum => 10000, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
                                                                        :min => 10, :max => 10000)
  validates_length_of :source, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.source"), :max => 20)
  validates_inclusion_of :category, :in => ["case", "knowledge"]
end
