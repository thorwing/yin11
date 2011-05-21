class Vendor
  include Mongoid::Document
  field :name

  attr_accessible :name

  #validators
  validates_presence_of :name
  validates_uniqueness_of :name

  #Relationships
  embeds_one :address
  has_many :reviews
  has_many :articles

end
