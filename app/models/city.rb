class City
  include Mongoid::Document

  field :code
  key :code
  field :name
  field :postcode
  field :eng_name
  field :latitude, :type => Float
  field :longitude, :type => Float

  #indexes
  index :name, :unique => true
  index :eng_name

  #scopes
  # strange error when trying to using scope, so using class method instead
  class << self
    def of_name(name)
      first(:conditions => {:name => name})
    end

    def of_eng_name(eng)
      first(:conditions => {:eng_name => eng})
    end
  end

  #Relationships
  belongs_to :province
  has_many :districts
  has_and_belongs_to_many :articles

  #Validators
  validates_presence_of :code, :name, :postcode
  validates_uniqueness_of :code, :name, :postcode
  validates_associated :districts

end
