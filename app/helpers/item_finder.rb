class ItemFinder
  def self.get_item(type, id)
    eval("#{type}.find(id)")
  end
end