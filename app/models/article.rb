class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include AssociatedModels
  include Votable

  scope :in_days_of, ->(days_in_number) {where(:created_at.gt => days_in_number.days.ago )}
  scope :about, ->(food) {any_in(food_ids: [food.is_a?(Food) ? food.id : food])}
  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :title
  field :source
  field :content

  #Relationships
  belongs_to :vendor
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :foods
  embeds_many :comments

  tokenize_many :cities, :foods
  tokenize_one :vendor

  attr_accessible :title, :source, :content

  validates_presence_of :title, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.title") )
  validates_length_of :title, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.title"), :max => 20)
  validates_presence_of :content, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.content") )
  validates_length_of :content, :minimum => 10, :maximum => 10000, :message => I18n.translate("validations.general.length_msg", :field => I18n.translate("general.content"),
  :min => 10, :max => 10000)
  validates_length_of :source, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.source"), :max => 20)

end
