require 'spec_helper'

describe City do
  it "simply create a city" do
    City.new(:name => "Beijing", :code => "010", :postcode => "10000").should be_valid
  end

  it "name is mandatory" do
    City.new(:code => "010", :postcode => "10000").should_not be_valid
  end

  it "code is mandatory" do
    City.new(:name => "Beijing", :postcode => "10000").should_not be_valid
  end

  it "postcode is mandatory" do
    City.new(:name => "Beijing", :code => "010").should_not be_valid
  end

  it "the of_name scope works" do
    beijing = Factory(:beijing)
    city = City.of_name("Beijing")
    city.should == beijing
  end

  it "the of_eng_name scope works" do
    beijing = Factory(:beijing)
    city = City.of_eng_name("BEIJING")
    city.should == beijing
  end

end