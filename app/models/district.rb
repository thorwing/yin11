class District
  include Mongoid::Document
  field :name

  #Relationships
  belongs_to :city

  validates_presence_of :name, :city
end
