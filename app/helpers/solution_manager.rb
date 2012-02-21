class SolutionManager
  def self.generate_solutions(desire, product_id = nil)
    if desire.solutions.size <= 9
      number = 9

      if desire.place
        desire.solutions.create do |s|
          s.place = desire.place
        end
        number = 8
      end
      #TODO
      #name_words = WordsProcessor.process(desire.content)

      if product_id.present?
        #create a solution as well
        desire.solutions.create do |s|
          s.product_id = product_id
        end
      end

      products =  []
      recipes = []
      if desire.content.present?
        products |= Product.where(name: /#{desire.content}/i).desc(:votes).limit(number)
        recipes |= Recipe.where(name: /#{desire.content}/i).desc(:votes).limit(number)
      end

      unless desire.tags.empty?
        products |= Product.tagged_with(desire.tags).desc(:votes).limit(number)
        recipes |= Recipe.tagged_with(desire.tags).desc(:votes).limit(number)
      end

      items = (products + recipes).sort{|i| -1 * i.votes}.take(number)
      items.each do |item|
        #TODO
        desire.solutions.create do |s|
          if item.is_a?(Product)
            s.product = item
          elsif item.is_a?(Recipe)
            s.recipe = item
          end
        end
      end
    end
  end
end