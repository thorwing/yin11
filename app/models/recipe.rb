class Recipe
    include Mongoid::Document
    field :name

    embeds_many :ingredients
    embeds_many :steps

    accepts_nested_attributes_for :ingredients
    accepts_nested_attributes_for :steps

    validates_presence_of :name
    validates_length_of :name, :maximum => 20
    validates_associated :ingredients

end
