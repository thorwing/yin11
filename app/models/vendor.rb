class Vendor
  include Mongoid::Document
  include Available
  include Locational
  scope :of_city, lambda { |city_name| where(:city => city_name)}

  field :name, :type => String
  field :verified, :type => Boolean, :default => false

  #Relationships
  has_many :reviews
  has_many :recommendations
  has_many :reports

  attr_accessible :name

  #validators
  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name"))
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))

end
