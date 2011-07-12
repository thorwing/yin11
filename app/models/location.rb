class Location
  include Mongoid::Document
  include Geocoder::Model::Mongoid
  include Gmaps4rails::ActsAsGmappable

  field :city
  field :detail
  field :coordinates, :type => Array
  geocoded_by :address
  acts_as_gmappable :lat => 'latitude', :lng => 'longitude', :process_geocoding => false

  #relationships
  embedded_in :vendor

  attr_accessible :city, :detail, :coordinates

  after_validation :geocode, :if => Proc.new {|location| location.new_record? || location.address_changed?}

  #virtual attributes
  def address
    [(self.city ? self.city : ""), (self.detail ? self.detail : "")].join(" ");
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