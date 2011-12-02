class Topic
  include Mongoid::Document
  include Taggable
  include Imageable

  field :title
  field :description
  field :priority, :type => Integer, :default => 100

  attr_accessible :title, :description, :priority

  #relationships
  has_many :articles
  has_many :images
  has_many :reviews

  #validators
  validates_presence_of :title
  validates_length_of :title, :maximum => 20
  validates_length_of :description, :maximum => 200
  validates_numericality_of :priority, :greater_than_or_equal_to => -100, :less_thanor_equal_to => 100
end