class Desire
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Imageable
  include Votable
  can_like

  field :content
  field :wanted_count, :type => Integer, :default => 0
  field :priority, :type => Integer, :default => 0

  attr_accessible :content, :priority

  #scopes
  scope :recommended, where(:priority.gt => 0)

  #relationships
  has_many :images
  has_many :reviews
  belongs_to :author, :class_name => "User"
  embeds_many :comments

  #validations
  validates_presence_of :author
  validates_length_of :content, :maximum => 280
end
