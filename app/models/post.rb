class Post
  include Mongoid::Document
  field :title
  field :content

  attr_accessible :title, :content, :group_id

  #relationships
  belongs_to :group
  embeds_many :comments

  #validations
  validates_presence_of :group
  validates_presence_of :title
  validates_length_of :title, :maximum => 30
  validates_presence_of :content
  validates_length_of :content, :maximum => 1000
end
