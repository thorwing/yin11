class Recipe
    include Mongoid::Document
    include Mongoid::Timestamps
    include Taggable

    #fields
    field :recipe_name

    attr_accessible  :author_id, :recipe_name , :ingredients_attributes, :steps_attributes

    #relationships
    embeds_many :ingredients
    embeds_many :steps
    belongs_to :author, :class_name => "User"

    accepts_nested_attributes_for :ingredients
    accepts_nested_attributes_for :steps

    #validations
    validates_presence_of :recipe_name
    validates_length_of :recipe_name, :maximum => 20
    validates_associated :ingredients
    validates_length_of :ingredients, :maximum => 10
    validates_length_of :steps, :maximum => 30
    validates_presence_of :author
    validates_associated :steps
    validates_associated :ingredients

    #callbacks
    before_save :strip_spaces
    before_save :sync_tag
    before_save :sync_image

    #TODO use a real image field here
    def image_url
      if self.steps.size > 0 && self.steps.last.image.picture?
        self.steps.last.image.picture_url
      else
        nil
      end
    end

    private

    def strip_spaces
       self.ingredients.each do |ingredient|
         ingredient.name.strip!
       end
    end

    def sync_tag
        self.tags |= self.ingredients.map(&:name)
    end

    def sync_image
      #p "before recipe sync_image"
      #p "self.img_id" + self.steps.img_id
      self.steps.each do |step|
        if step.img_id.present?
          #&& (step.img_id.changed? || step.new_record?)
          image = Image.first(conditions: {id: step.img_id})
          if image
            image.step_id = step.id
            image.save!
          end
        end
      end
    end
end
