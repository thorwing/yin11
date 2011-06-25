class Toxin
  include Mongoid::Document

  #relationships
  has_and_belongs_to_many :reviews
  has_and_belongs_to_many :recommendations
  has_and_belongs_to_many :articles
end