class District
  include Mongoid::Document
  field :name, :type => String

  #Relationships
  belongs_to :city
end
