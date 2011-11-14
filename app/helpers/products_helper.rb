module ProductsHelper
  def nested_catalogs(catalogs)
    catalogs.map do |catalog, sub_catalogs|
      result = ""
      if catalog.parent.blank?
        result += link_to(catalog.name, {:action => "index", :category => catalog.name}) + ": "
      else
        result += link_to(catalog.name, {:action => "index", :category => catalog.name}) + " "
      end
      result += nested_catalogs(sub_catalogs)
      result += "<br/>" unless catalog.parent
      result
    end.join.html_safe
  end

  #def get_categories_for_select
  #  Tag.categories.map do |c|
  #    category_name = c.parent ? "--" + c.name : c.name
  #    [category_name, c.name]
  #  end
  #end
end
