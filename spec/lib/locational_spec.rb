require "spec_helper"

describe "Locational" do
  class LocationalSample
    include Mongoid::Document
    include Locational
  end

  it "it works" do
    e = LocationalSample.new
    e.respond_to?(:city).should == true
    e.respond_to?(:street).should == true
    e.respond_to?(:location).should == true
    e.respond_to?(:address).should == true
    e.respond_to?(:latitude).should == true
    e.respond_to?(:longitude).should == true
  end

  it "address works" do
    e = LocationalSample.new(:city => "shanghai", :street => "nanjing road")
    e.city.should == "shanghai"
    e.street.should == "nanjing road"
    e.address.should == "shanghai nanjing road"
  end

  it "geocoding works" do
    e = LocationalSample.create(:city => "shanghai", :street => "nanjing road")
    #TODO
    #e.location.should_not be_nil
    e.latitude.should > 0
    e.longitude.should > 0
  end

end