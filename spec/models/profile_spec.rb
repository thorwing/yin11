require 'spec_helper'

describe Profile do
  it "it works" do
    Profile.new.should be_valid
  end

  it "fields have default values" do
    profile = Profile.new
    profile.watched_foods.should == []
    profile.receive_mails == true
    profile.watched_distance == 2
  end

  it "watched_distance is limited" do
    Profile.new(:watched_distance => 0).should_not be_valid
    Profile.new(:watched_distance => 6).should_not be_valid
  end

  it "add_foods works" do
    profile = Profile.new
    profile.add_foods(["milk", "pork", "milk"])
    profile.watched_foods.should == ["milk", "pork"]
  end

end
