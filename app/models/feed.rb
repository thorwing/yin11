class Feed
  include Mongoid::Document
  include Mongoid::Timestamps

  field :target_type
  field :target_id

  #relationships
  embedded_in :user

end