class Vendor
  include Mongoid::Document

  field :name
  field :is_tmall, :type => Boolean, :default => false
  field :url
  field :seller_credit_score, :type => Integer

  attr_accessible :name, :mall_id

  #Relationships
  has_many :products

  #validators
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 60

end
