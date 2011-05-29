class Checkpoint
  include Mongoid::Document

  field :pass, :type => Boolean, :default => true

  #relationships
  embedded_in :review
  belongs_to :tip

end