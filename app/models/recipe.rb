class Recipe
  include Mongoid::Document
   has_many :ingredients
   has_many :steps
end
