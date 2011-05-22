require 'spec_helper'

describe "bvt" do
  it "simply create a city" do
    city = Factory.create(:city, :name => "test", :code => "021", :postcode => "200001")
    city.should_not be_new_record
    city.should_not be_nil
  end

  it "name is required" do
    city = Factory.build(:city, :code => "021", :postcode => "200001")
    city.valid?.should equal false
  end

  it "code is required" do
    city = Factory.build(:city, :name => "test", :postcode => "200001" )
    city.valid?.should equal false
  end

   it "postcode is required" do
    city = Factory.build(:city, :name => "test", :code => "021" )
    city.valid?.should equal false
  end
end