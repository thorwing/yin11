class Vendor
  include Mongoid::Document
  field :name, :type => String

  #Relationships
  has_many :products

end
