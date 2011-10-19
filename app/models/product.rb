class Product
  include Mongoid::Document
  include AssociatedModels
  include Taggable
  include Followable
  field :name
  field :url

  attr_accessible :name, :url, :vendor_id

  #relationships
  embeds_many :comments
  belongs_to :vendor
  tokenize_one :vendor

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
  validates_presence_of :vendor

end