require 'spec_helper'

describe City do
  describe "bvt" do
    it "simply create a city" do
      city = Factory.create(:city, :name => "Beijing", :code => "010", :postcode => "10000")
      city.should_not be_new_record
      city.should_not be_nil
    end

    it "name is required" do
      city = Factory.build(:city, :code => "010", :postcode => "10000")
      city.valid?.should equal false
    end

    it "code is required" do
      city = Factory.build(:city, :name => "Beijing", :postcode => "10000" )
      city.valid?.should equal false
    end

     it "postcode is required" do
      city = Factory.build(:city, :name => "Beijing", :code => "010" )
      city.valid?.should equal false
    end
  end
end