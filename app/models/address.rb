class Address
  include Mongoid::Document
  include AssociatedModels

  field :street
  field :building
  field :postcode

  def detail
    [self.street, self.building].join(" ")
  end

  def detail=(address_detail)
    self.street, self.building = address_detail.split(" ", 2)
  end

  #cached_values
  associate_models :City, :Province, :Area
  tokenize_one :city, :province

  #Relationships
  embedded_in :profile
  embedded_in :vendor

  validates_length_of :street, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("address.street"), :max => 20)
  validates_length_of :building, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("address.building"), :max => 20)
  validates_length_of :postcode, :maximum => 10, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("address.postcode"), :max => 20)

end