class District
  include Mongoid::Document
  field :name

  #Relationships
  belongs_to :city
end