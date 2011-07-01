class Vendor
  include Mongoid::Document
  include Available
  field :name
  field :verified, :type => Boolean, :default => false

  #Relationships
  embeds_one :address
  has_many :reviews
  has_many :articles

  attr_accessible :name, :address_attributes

  #validators
  validates_presence_of :name, :message => I18n.translate("validations.general.presence_msg", :field => I18n.translate("general.name"))
  validates_uniqueness_of :name, :message => I18n.translate("validations.general.uniqueness_msg", :field => I18n.translate("general.name"))

  accepts_nested_attributes_for :address, :allow_destroy => true

  before_save :update_address

  def update_address
    self.address.detail = self.name if self.address
  end

end
