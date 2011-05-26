class Article
  include Mongoid::Document
  include AssociatedModels
  include Available
  include Informative

  scope :in_days_of, ->(days_in_number) {where(:created_at.gt => days_in_number.days.ago )}
  scope :about, ->(food) {any_in(food_ids: [food.is_a?(Food) ? food.id : food])}
  scope :in_city, ->(city) {any_in(city_ids: [city.is_a?(City) ? city.id : city])}
  scope :not_in_city, ->(city) {not_in(city_ids: [city.is_a?(City) ? city.id : city])}

  field :source

  #Relationships
  belongs_to :vendor
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :foods
  has_many :images

  tokenize_many :cities, :foods
  tokenize_one :vendor

  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:image].blank? && i[:remote_image_url].blank? }, :allow_destroy => true

  attr_accessible :source, :images_attributes

  validates_length_of :source, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("general.source"), :max => 20)

end
