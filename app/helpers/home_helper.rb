module HomeHelper
  def get_bad_items_near_by(location)
    vendors = Vendor.near("location.coordinates" => location.coordinates)
    vendors
  end
end
