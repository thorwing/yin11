class Vendor
  include Mongoid::Document
  include Mongoid::Timestamps
  include Available
  include Followable

  field :name
  field :verified, :type => Boolean, :default => false
  field :is_tmall, :type => Boolean

  attr_accessible :name

  #Relationships
  has_many :products
  belongs_to :creator, :class_name => "User"
  embeds_many :feeds

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30

end
