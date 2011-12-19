require 'spec_helper'

describe Recipe do
    it "simpley create a article" do
      step = Recipe.steps.build
      step.content = "test"
      #right now, I can not add a img here

      ingredient = Recipe.ingredients.build
      ingredient.name = "test"
      ingredient.amount = "1"

      @editor = Factory(:editor)
      @editor.should be_valid
      Article.new(:name => "test", :steps => step, :ingredients => ingredient, :author_id=> @editor.id).should be_valid
    end
end
