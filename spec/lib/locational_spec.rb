require "spec_helper"

describe "Locational" do
  class Sample
    include Mongoid::Document
    include Locational
  end

  it "it works" do
    e = Sample.new
    e.respond_to?(:city).should == true
    e.respond_to?(:street).should == true
    e.respond_to?(:coordinates).should == true
    e.respond_to?(:address).should == true
    e.respond_to?(:latitude).should == true
    e.respond_to?(:longitude).should == true
    e.respond_to?(:not_geocoded?).should == true
  end

  it "address works" do
    e = Sample.new(:city => "shanghai", :street => "nanjing road")
    e.city.should == "shanghai"
    e.street.should == "nanjing road"
    e.address.should == "shanghai nanjing road"
  end

  it "geocoding works" do
    e = Sample.create(:city => "shanghai", :street => "nanjing road")
    e.coordinates.should_not be_nil
    e.latitude.should > 0
    e.longitude.should > 0
  end

end