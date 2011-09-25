class Relationship
  include Mongoid::Document

  field :target_type, :type => String
  field :target_id, :type => String

  #relationships
  embedded_in :user

end