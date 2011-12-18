class Mall
  include Mongoid::Document

  field :name
  field :entry_url
  attr_accessible :name, :entry_url

  #Relationships
  has_many :vendors

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
end