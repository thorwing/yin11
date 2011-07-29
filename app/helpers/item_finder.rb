class ItemFinder
  def self.get_item(type, id)
    eval("#{type}.find(id)")
  end

  def self.get_region(region_id)
    region = City.first(:conditions => {:id => region_id})
    region = Province.first(:conditions => {:id => region_id}) unless region
    region
  end
end