class Product
  include Mongoid::Document

  #Relationships
  belongs_to :food
  belongs_to :vendor
  has_many :reviews

end
