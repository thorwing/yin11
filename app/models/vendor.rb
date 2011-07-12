class Vendor
  include Mongoid::Document
  include Available
  scope :of_city, lambda { |city_name| where("location.city" => city_name)}

  field :name, :type => String
  field :verified, :type => Boolean, :default => false

  #Relationships
  embeds_one :location
  has_many :reviews
  has_many :recommendations
  has_many :reports

  accepts_nested_attributes_for :location, :allow_destroy => true
  attr_accessible :name, :location_attributes

  #validators
  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name"))
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))
  validates_associated :location

end
