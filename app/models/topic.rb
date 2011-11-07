class Topic
  include Mongoid::Document
  include Taggable

  field :title
  field :description
  field :recommendation, :type => Integer, :default => 0

  attr_accessible :title, :description, :recommendation

  #validators
  validates_presence_of :title
  validates_length_of :title, :maximum => 20
  validates_length_of :description, :maximum => 200
  validates_numericality_of :recommendation, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
end