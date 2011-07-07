class Vendor
  include Mongoid::Document
  include Available
  field :name, :type => String
  field :verified, :type => Boolean, :default => false

  #Relationships
  embeds_one :address
  has_many :reviews
  has_many :recommendations
  has_many :reports

  accepts_nested_attributes_for :address, :allow_destroy => true
  attr_accessible :name, :address_attributes

  #validators
  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name"))
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))

  def get_address
    address = ""
    address += [self.address.city.name, self.address.detail].join(" ") if self.address && self.address.city
    address
  end

end
