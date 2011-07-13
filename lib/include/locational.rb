#maybe need to run db.locations.ensureIndex({ coordinates: "2d" })

module Locational
  def self.included(base)
    base.class_eval do
      include Geocoder::Model::Mongoid
      include Gmaps4rails::ActsAsGmappable

      field :city
      field :street
      field :coordinates, :type => Array
      index [[ :coordinates, Mongo::GEO2D ]], :min => -180, :max => 180
      geocoded_by :address
      acts_as_gmappable :lat => 'latitude', :lng => 'longitude', :process_geocoding => false

      attr_accessible :city, :street, :coordinates

      after_validation :geocode, :if => Proc.new {|location| location.new_record? || location.city_changed? || location.street_changed? }

      include InstanceMethods
    end
  end

  module InstanceMethods
    def address
      [(self.city ? self.city : ""), (self.street ? self.street : "")].join(" ");
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

end