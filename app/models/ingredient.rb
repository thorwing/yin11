class Ingredient
  include Mongoid::Document

    #fields
  field :name, :type => String
  field :amount, :type => String
  field :is_major_ingredient, :type => Boolean ,:default => true
  attr_accessible  :name, :amount, :is_major_ingredient

      #relationships
  embedded_in :recipe

      #validations
  validates_presence_of :name
  validates_length_of :name, :maximum => 15
  validates_length_of :amount, :maximum => 10
end
