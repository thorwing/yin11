class Product
  include Mongoid::Document
  include AssociatedModels
  include Taggable
  include Followable
  field :name
  field :price, :type => Float
  field :weight, :type => Float
  field :producer
  field :original_place
  field :authenticated
  field :description
  field :url

  attr_accessible :name, :url, :vendor_id

  #relationships
  embeds_many :comments
  belongs_to :vendor
  tokenize_one :vendor
  has_one :image
  belongs_to :category

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 100
  validates_presence_of :vendor

end
