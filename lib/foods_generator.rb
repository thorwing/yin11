class FoodsGenerator
  def self.generate_foods
    traverse(YAML.load(File.open("#{Rails.root.to_s}/app/assets/foods.yml")), nil)
  end

  protected

  def self.traverse(obj, parent)
    if obj.is_a?(Hash)
      obj.each do |k,v|
        if v.is_a?(Array)
          add_food(k, parent, v)
        else
          add_category(k, parent)
          traverse(v, k)
        end
      end
    end
  end

  def self.add_food(name, category, aliases)
    puts category + " << " + name + ": " + aliases.to_s
    food = Food.first(conditions: {name: name})
    food ||= Food.new(:name => name)
    category = Category.first(conditions: {name: category})

    food.category_ids ||= []
    food.category_ids << category.id
    food.aliases = aliases
    food.save

    category.food_ids ||= []
    category.food_ids << food.id
    category.save
  end

  def self.add_category(name, parent)
    parent_category = parent.present? ? Category.first(conditions: {name: parent}) : nil
    if parent_category
      puts parent_category.name + " -> " + name
      parent_category.children.create(:name => name)
    else
      #puts node
      Category.create(:name => name)
    end
  end

end