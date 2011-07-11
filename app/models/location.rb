class Location
  include Mongoid::Document
  include Geocoder::Model::Mongoid
  include Gmaps4rails::ActsAsGmappable

  field :address
  field :coordinates, :type => Array
  geocoded_by :address
  acts_as_gmappable :lat => 'latitude', :lng => 'longitude', :process_geocoding => false

  #relationships
  embedded_in :vendor

  attr_accessible :address, :coordinates

  after_validation :geocode, :if => Proc.new {|location| location.new_record? || location.address_changed?}

  #virtual attributes
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