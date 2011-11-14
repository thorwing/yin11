class Catalog
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry

  field :name
  key :name

  attr_accessible :name

  #relationships
  has_and_belongs_to_many :products

  #validations
  validates_length_of :name, :maximum => 20

end