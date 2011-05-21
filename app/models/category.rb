class Category
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry

  field :name
  #key :name
  field :ancestry
  index :ancestry

  #relationships
  has_and_belongs_to_many :foods

end