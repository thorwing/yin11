class Checkpoint
  include Mongoid::Document

  field :name, :type => String
  field :pass, :type => Boolean, :default => true

  #relationships
  embedded_in :review

end