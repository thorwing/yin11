class Recipe
   include Mongoid::Document
   has_many :ingredients
   has_many :steps

  accepts_nested_attributes_for :ingredients
  accepts_nested_attributes_for :steps
  #validates_presence_of :title
  #validates_length_of :title, :maximum => 30
end
