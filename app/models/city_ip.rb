class CityIp
  include Mongoid::Document

  field :start_ip, :type => Integer
  field :end_ip, :type => Integer
  field :province_name, :type => String
  field :city_name, :type => String

end