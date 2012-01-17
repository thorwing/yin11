class Desire
  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable
  include Imageable

  field :content
  #field :admired_count, :type => Integer, :default => 0
  #field :admirers_ids, :type => Array, :default => []
  field :priority, :type => Integer, :default => 0

  attr_accessible :content, :priority

  #scopes
  scope :recommended, where(:priority.gt => 0)

  #relationships
  has_many :images
  has_many :reviews
  belongs_to :author, :class_name => "User"
  has_and_belongs_to_many :admirers, :class_name => "User", :inverse_of => "admired_desires", :index => true
  #embeds_many :comments

  #validations
  validates_presence_of :author
  validates_length_of :content, :maximum => 280
end
