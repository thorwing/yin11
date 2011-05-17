class Revision
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content

  #Relationships
  belongs_to :tip

end
