class Food
  include Mongoid::Document
  field :name
  key :name

  #Relationships
  has_and_belongs_to_many :articles
  has_many :reviews
  has_and_belongs_to_many :categories

  #validators
  validates_uniqueness_of :name
end
