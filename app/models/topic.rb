class Topic
  include Mongoid::Document
  include Taggable

  field :title
  field :priority, :type => Integer, :default => 100
  field :content

  attr_accessible :title, :description, :content, :priority

  #validators
  validates_presence_of :title
  validates_length_of :title, :maximum => 20
  validates_numericality_of :priority, :greater_than_or_equal_to => -100, :less_thanor_equal_to => 100
end