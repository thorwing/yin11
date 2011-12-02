class Recipe
  include Mongoid::Document
   has_many :materials
   has_many :steps
end
