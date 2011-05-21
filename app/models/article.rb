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

  tokenize_many :cities, :foods
  tokenize_one :vendor

  attr_accessible :title, :source, :content

end
