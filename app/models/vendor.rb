class Vendor
  include Mongoid::Document

  field :name
  field :is_tmall, :type => Boolean
  field :url

  attr_accessible :name, :mall_id

  #Relationships
  belongs_to :mall
  has_many :products
  embeds_many :feeds

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30

end
