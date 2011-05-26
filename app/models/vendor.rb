class Vendor
  include Mongoid::Document
  include Available
  field :name
  field :verified, :type => Boolean, :default => false
  attr_accessible :name

  #validators
  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name"))
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))

  #Relationships
  embeds_one :address
  has_many :reviews
  has_many :articles

end
