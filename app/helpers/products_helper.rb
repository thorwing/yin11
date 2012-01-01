module ProductsHelper
  def first_catalogs(catalogs)
    catalogs.reject{|c| c.parent.present?}
  end

  def nested_catalogs(catalogs)
    catalogs.map do |catalog, sub_catalogs|
      result = ""
      return result unless catalog.show

      link = link_to(catalog.name, products_path(:action => "index", :catalog => catalog.name))
      ancestors_cnt = catalog.ancestor_ids.size
      case ancestors_cnt
        when 0

        when 1
          result += content_tag(:span, link, :class => "cat second")
        else
          result += content_tag(:span, link, :class => "cat third")
      end

      result += nested_catalogs(catalog.children)
      result += "<br/>" if ancestors_cnt == 1
      result
    end.join.html_safe
  end
end
