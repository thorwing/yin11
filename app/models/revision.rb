class Revision
  include Mongoid::Document

  field :title
  field :content
  field :time_stamp, :type => DateTime

  attr_accessible :title, :content, :author_id, :time_stamp

  #Relationships
  embedded_in :tip
  belongs_to :author, :class_name => "User"

  validates_presence_of :author, :content
  validates_length_of :content, :maximum => 140

end
