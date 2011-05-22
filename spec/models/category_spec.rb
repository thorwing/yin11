require 'spec_helper'

describe "bvt" do
  it "simply create a category" do
    @category = Factory.create(:category, :name => "test")
    @category.should_not be_new_record
    @category.should_not be_nil
  end

   it "category' name is required" do
    category = Factory.build(:category)
    category.valid?.should equal false
  end

  it "categories' names are unique" do
    Factory.create(:category, :name => "test")
    category = Factory.build(:category, :name => "test")
    category.valid?.should equal false
  end
end