class Ingredient
  include Mongoid::Document

  field :name, :type => String
  field :amount, :type => String

  embedded_in :recipe

  validates_presence_of :name
  validates_length_of :name, :maximum => 30

  validates_presence_of :amount
  validates_length_of :amount, :maximum => 30
end
