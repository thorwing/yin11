class City
  include Mongoid::Document
  field :code
  key :code
  field :name
  field :postcode
  field :name_en

  #Relationships
  belongs_to :province
  has_many :districts
  has_and_belongs_to_many :articles

  #Validators
  validates_presence_of :code, :name, :postcode
  validates_uniqueness_of :code, :name, :postcode
  validates_associated :districts
end
