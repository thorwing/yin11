class Tag
  include Mongoid::Document

  field :title
  key :title

  #relationships
  has_and_belongs_to_many :tips

  attr_accessible :title
  validates_uniqueness_of :title
  validates_presence_of :title
  validates_length_of :title, :maximum => 10

end
