class Ingredient
  include Mongoid::Document
  field :name, :type => String
  field :amount, :type => String
end
