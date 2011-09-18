#maybe need to run db.locations.ensureIndex({ coordinates: "2d" })

module Locational
  def self.included(base)
    base.class_eval do
      include Gmaps4rails::ActsAsGmappable

      field :city
      field :street
      field :latitude, :type => Float
      field :longitude, :type => Float
      field :location, :type => Array, :geo => true, :lat => :latitude, :lng => :longitude

      index [[ :location, Mongo::GEO2D ]], :min => -180, :max => 180

      acts_as_gmappable :checker => :prevent_geocoding

      scope :from_cities, lambda { |city_names| any_in(:city => city_names) }

      attr_accessible :city, :street, :latitude, :longitude

      #after_validation :geocode, :if => Proc.new {|location| (location.new_record? || location.city_changed? || location.street_changed?) && location.street.present? }

      include InstanceMethods
    end
  end

  module InstanceMethods
    def gmaps4rails_address
      #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
      "#{self.street}, #{self.city}, #{I18n.t("location.default_country")}"
    end

    def address
      [(self.city ? self.city : ""), (self.street ? self.street : "")].join(" ")
    end

    def prevent_geocoding
      street.blank?
    end
    #
    #def latitude
    #  self.coordinates[1]
    #end
    #
    #def longitude
    #  self.coordinates[0]
    #end
    #
    #def not_geocoded?
    #  self.coordinates.nil? || self.coordinates.empty?
    #end
  end

end