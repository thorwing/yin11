require 'spec_helper'

describe "bvt" do
  it "simply create a food" do
    food = Factory.create(:food, :name => "test")
    food.should_not be_new_record
    food.should_not be_nil
  end

   it "food' name is required" do
    food = Factory.build(:food)
    food.valid?.should equal false
  end

  it "food' names are unique" do
    Factory.create(:food, :name => "test")
    food = Factory.build(:food, :name => "test")
    food.valid?.should equal false
  end
end