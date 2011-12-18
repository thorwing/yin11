class Mall
  include Mongoid::Document

  field :name
  attr_accessible :name

  #Relationships
  has_many :vendors

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
end