class City
  include Mongoid::Document
  field :code
  key :code
  field :name
  field :post_code

  #Relationships
  belongs_to :province
  has_many :areas
  has_and_belongs_to_many :articles

  #Validators
  validates_presence_of :code, :name, :post_code
  validates_uniqueness_of :code, :name, :post_code
  validates_associated :areas
end
