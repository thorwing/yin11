class Location
  include Mongoid::Document
  include Geocoder::Model::Mongoid
  include Gmaps4rails::ActsAsGmappable

  field :city
  field :street
  field :coordinates, :type => Array
  geocoded_by :address
  acts_as_gmappable :lat => 'latitude', :lng => 'longitude', :process_geocoding => false

  attr_accessible :city, :street

  #relationships
  embedded_in :profile

  after_validation :geocode, :if => Proc.new {|location| location.new_record? || location.city_changed? || location.street_changed? }

  #virtual attributes
  def address
    address = (self.city ? self.city : "")
    address += " " + self.street if self.street.present?
    address
  end

  def latitude
    self.coordinates[1]
  end

  def longitude
    self.coordinates[0]
  end

  def not_geocoded?
    self.coordinates.nil? || self.coordinates.empty?
  end

end