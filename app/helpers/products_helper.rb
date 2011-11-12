module ProductsHelper
  def nested_categories(categories)
    categories.map do |category, sub_categories|
      result = ""
      if category.parent.blank?
        result += link_to(category.name, {:action => "index", :category => category.name}) + ": "
      else
        result += link_to(category.name, {:action => "index", :category => category.name}) + " "
      end
      result += nested_categories(sub_categories)
      result += "<br/>" unless category.parent
      result
    end.join.html_safe
  end

  def get_categories_for_select
    Tag.categories.map do |c|
      category_name = c.parent ? "--" + c.name : c.name
      [category_name, c.name]
    end
  end
end
