class Food
  include Mongoid::Document
  field :name
  key :name

  #Relationships
  has_and_belongs_to_many :articles
  has_many :reviews

  #validators
  validates_uniqueness_of :name
end
