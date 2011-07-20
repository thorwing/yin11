class Revision
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :content

  attr_accessible :title, :content, :author_id

  #Relationships
  embedded_in :tip
  belongs_to :author, :class_name => "User"

  validates_presence_of :author, :content
  validates_length_of :content, :maximum => 140

end
