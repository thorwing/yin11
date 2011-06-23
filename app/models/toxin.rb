class Toxin
  include Mongoid::Document
  include Taggable

  #relationships
  has_and_belongs_to_many :reviews
  has_and_belongs_to_many :recommendations
  has_and_belongs_to_many :articles
end