class Address
  include Mongoid::Document
  include AssociatedModels

  field :street
  field :building

  def detail
    [self.street, self.building].join(" ")
  end

  def detail=(address_detail)
    self.street, self.building = address_detail.split(" ", 2)
  end

  #cached_values
  associate_models :City, :Province, :Area

  #  field :city_id
#  field :province_id
#  field :area_id
#
#  def city
#    city = City.find(self.city_id)
#    city
#  end
#
#  def province
#    province = City.find(self.province_id)
#    province
#  end
#
#  def area
#    area = Area.find(self.area_id)
#    area
#  end

  #Relationships
  embedded_in :profile
  embedded_in :vendor


end