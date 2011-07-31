class Vendor
  include Mongoid::Document
  include Available
  include Locational

  field :name
  field :verified, :type => Boolean, :default => false

  attr_accessible :name

  scope :of_city, lambda { |city_name| where(:city => city_name)}

  #Relationships
  has_many :reviews
  has_many :reports

  #validators
  validates_presence_of :name
  validates_length_of :name, :maximum => 20
  validates_presence_of :city
  validates_presence_of :street
  validates_uniqueness_of :full_name

  def full_name
    (name.nil? ? "" : name.strip) + " (" + address + ")"
  end
end
