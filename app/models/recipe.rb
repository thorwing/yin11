class Recipe
    include Mongoid::Document
    include Taggable
    field :recipe_name
    attr_accessible  :author_id, :recipe_name , :ingredients_attributes, :steps_attributes

    embeds_many :ingredients
    embeds_many :steps
    belongs_to :author, :class_name => "User"

    accepts_nested_attributes_for :ingredients
    accepts_nested_attributes_for :steps

    validates_presence_of :recipe_name
    validates_length_of :recipe_name, :maximum => 20
    validates_associated :ingredients
    validates_length_of :ingredients, :maximum => 10
    validates_length_of :steps, :maximum => 30
    validates_presence_of :author
end
