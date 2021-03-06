class SolutionManager

  def self.generate_product_solution(desire, product_id, user = nil)
    if product_id.present?
      desire.solutions.create do |s|
        s.product_id = product_id
        s.author = user if user.present?
      end
    end
  end

  def self.generate_tuan_solution(desire, tuan_id, user = nil)
    if tuan_id.present?
      desire.solutions.create do |s|
        s.tuan_id = tuan_id
        s.author = user if user.present?
      end
    end
  end


  def self.generate_solutions(desire, product_id = nil, user = nil)
    if desire.solutions.size <= 9
      number = 9

      #default solution for place
      #if desire.place && user.present?
      #  desire.solutions.create do |s|
      #    s.place = desire.place
      #    s.author = user
      #  end
      #  number = 8
      #end

      #default solution for product
      if product_id.present? && user.present?
        desire.solutions.create do |s|
          s.product_id = product_id
          s.author = user
        end
        number = 8
      end

      #products =  []
      #recipes = []
      #if desire.content.present?
      #  products |= Product.where(name: /#{desire.content}/i).desc(:votes).limit(3)
      #  recipes |= Recipe.where(name: /#{desire.content}/i).desc(:votes).limit(3)
      #end
      #
      #unless desire.tags.empty?
      #  products |= Product.tagged_with(desire.tags).desc(:votes).limit(3)
      #  recipes |= Recipe.tagged_with(desire.tags).desc(:votes).limit(3)
      #end
      #
      #items = (products.uniq + recipes.uniq).sort{|i| -1 * i.votes}.take(3)
      #items.each do |item|
      #  desire.solutions.create do |s|
      #    if item.is_a?(Product)
      #      s.product = item
      #    elsif item.is_a?(Recipe)
      #      s.recipe = item
      #    end
      #  end
      #end
    end
  end
end