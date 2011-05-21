class FoodsGenerator
  def self.generate_foods
    traverse(YAML.load(File.open("#{Rails.root.to_s}/app/assets/foods.yml")), nil) do |node, parent|
      next unless node
      parent_category = parent.present? ? Category.first(conditions: {name: parent}) : nil
      if parent_category
        #puts parent_category.name + " -> " + node
        parent_category.children.create(:name => node)
      else
        #puts node
        Category.create(:name => node)
      end
    end
  end

  protected

  def self.add_food(name, category)
    #puts category + " << " + name
    food = Food.first(conditions: {name: name})
    food ||= Food.new(:name => name)
    category = Category.first(conditions: {name: category})

    food.category_ids ||= []
    food.category_ids << category.id
    food.save

    category.food_ids ||= []
    category.food_ids << food.id
    category.save
  end

  def self.traverse(obj, parent, &blk)
    case obj
    when Hash
      obj.each { |k,v| blk.call(k, parent); traverse(v, k, &blk)}
    when Array
      obj.each {|v| add_food(v, parent)}
    else
      blk.call(obj, parent)
    end
  end

end