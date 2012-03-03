class Recipe
    include Mongoid::Document
    include Mongoid::Timestamps
    include Taggable
    include Votable
    include Imageable
    include Feedable
    include Recommendable
    include SilverSphinxModel

    #fields
    field :name
    field :notice

    search_index(:fields => [:name, :tags],
              :attributes => [:created_at])

    attr_accessible  :author_id, :name, :ingredients_attributes, :steps_attributes, :notice

    #relationships
    embeds_many :ingredients
    embeds_many :steps
    belongs_to :author, :class_name => "User", index: true
    #has_and_belongs_to_many :reviews
    embeds_many :feeds
    embeds_many :comments
    has_many :solutions

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
    validates_length_of :notice, :maximum => 600

    #callbacks
    #mongoid doesn't call create/update callback on embedded documents
    before_save :sync_children

    #TODO use a real image field here
    def image
      #the last step who has an image
      image = nil
      self.steps ||= []
      steps_with_image = self.steps.select{|s| s.image.present?}
      image = steps_with_image.last.get_image unless steps_with_image.empty?
      image
    end

    def instruction
      text = self.steps.map(&:content).join("    ") || ""
    end

    def major_ingredients
      self.ingredients.where(is_major_ingredient: true)
    end

     def minor_ingredients
      self.ingredients.where(is_major_ingredient: false)
    end

    private

    def sync_children
      self.ingredients.each do |ingredient|
       ingredient.name.strip!
      end

      self.steps.each do |step|
        if step.img_id.present?
          image = Image.first(conditions: {id: step.img_id})
          if image
            image.step_id = step.id
            image.save
          end
        end
      end
    end

end
