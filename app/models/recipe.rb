class Recipe
    include Mongoid::Document
    include Mongoid::Timestamps
    include Taggable
    include SilverSphinxModel
    include Imageable
    include Followable

    #fields
    field :name
    field :description

    search_index(:fields => [:name],
              :attributes => [:updated_at, :created_at])

    attr_accessible  :author_id, :name , :ingredients_attributes, :steps_attributes, :description

    #relationships
    embeds_many :ingredients
    embeds_many :steps
    belongs_to :author, :class_name => "User"
    has_many :reviews
    embeds_many :comments

    accepts_nested_attributes_for :ingredients, :reject_if => lambda { |i| i[:name].blank?}, :allow_destroy => true
    accepts_nested_attributes_for :steps, :reject_if => lambda { |s| s[:img_id].blank? && s[:content].blank? }, :allow_destroy => true

    #validations
    validates_presence_of :name
    validates_length_of :name, :maximum => 20
    validates_associated :ingredients
    validates_length_of :ingredients, :maximum => 16
    validates_length_of :steps, :maximum => 30
    validates_presence_of :author
    validates_associated :steps
    validates_associated :ingredients
    validates_length_of :description, :maximum => 300

    #callbacks
    before_save :strip_spaces
    before_save :sync_tag
    before_save :sync_image

    #TODO use a real image field here
    def image
      image = nil
      image = self.steps.last.get_image if (self.steps.size > 0 && self.steps.last.image.present?)
      image
    end

    def instruction
      #TODO
      text = self.steps.map(&:content).join("    ") || ""
      limit = 40
      if text.size > limit
        text[0..(limit - 4)] + "..."
      else
        text
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
