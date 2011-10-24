class Category
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry

  #relationships
  has_many :products
end