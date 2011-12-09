class Ingredient
  include Mongoid::Document

  field :name, :type => String
  field :amount, :type => String
  field :is_major_ingredient, :type => Boolean ,:default => true

  attr_accessible  :name, :amount, :is_major_ingredient
  embedded_in :recipe

  validates_presence_of :name
  validates_length_of :name, :maximum => 20

  validates_presence_of :amount
  validates_length_of :amount, :maximum => 10
end
