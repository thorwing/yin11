class Location
  include Mongoid::Document
  include Locational

  #relationships
  embedded_in :profile

end