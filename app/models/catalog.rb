class Catalog
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry

  field :name
  #key :name
  field :show, :type => Boolean

  field :alias_name, :type => Array


  attr_accessible :name, :show , :alias_name

  #relationships
  has_and_belongs_to_many :products

  #validations
  validates_presence_of :name
  validates_length_of :name, :maximum => 20

end