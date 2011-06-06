class Address
  include Mongoid::Document
  include AssociatedModels

  field :street
  field :place
  field :postcode
  field :point_lng, :type => Float
  field :point_lat, :type => Float

  def point
    [self.point_lng.to_s, self.point_lat.to_s].join(",")
  end

  def point=(address_point)
    self.point_lng = address_point.split(",")[0].to_f
    self.point_lat = address_point.split(",")[1].to_f
  end

  def detail
    [self.street, self.place].join(" ")
  end

  def detail=(address_detail)
    self.street, self.place = address_detail.split(" ", 2)
  end

  #cached_values
  associate_models :City, :Province, :District
  tokenize_one :city, :province, :district

  #Relationships
  embedded_in :profile
  embedded_in :vendor

  validates_length_of :street, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("address.street"), :max => 20)
  validates_length_of :place, :maximum => 20, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("address.place"), :max => 20)
  validates_length_of :postcode, :maximum => 10, :message => I18n.translate("validations.general.max_length_msg", :field => I18n.translate("address.postcode"), :max => 20)

  attr_accessible :city_id, :street, :place, :detail, :point

end