class Province
  include Mongoid::Document
  field :code
  key :code
  field :name
  field :short_name
  field :type
  field :main_city_id

  #Relationships
  has_many :cities

  #Validators
  validates_presence_of :code, :name
  validates_uniqueness_of :code, :name
  validates_associated :cities

end
