require "spec_helper"

describe Vendor do
  let(:beijing) {Factory(:beijing)}

  it "it should be valid" do
    Vendor.new(:name => "test", :city => "shanghai", :street => "dahua road").should be_valid
  end

  it "name is mandatory" do
    Vendor.new(:city => "shanghai", :street => "dahua road").should_not be_valid
  end

  it "city is mandatory" do
    Vendor.new(:name => "test", :street => "dahua road").should_not be_valid
  end

  it "street is mandatory" do
    Vendor.new(:name => "test", :city => "shanghai").should_not be_valid
  end

  it "name is not unique" do
    Vendor.create(:name => "test", :city => "shanghai", :street => "dahua road")
    Vendor.new(:name => "test", :city => "beijing", :street => "changan road").should be_valid
  end

  it "type must be of certain value" do
    Vendor.create(:name => "test", :city => "shanghai", :street => "dahua road", :category => "test").should_not be_valid
  end

  #TODO
  #it "full address is unique" do
  #  Vendor.create(:name => "test", :city => "shanghai", :street => "dahua road")
  #  Vendor.new(:name => "test", :city => "shanghai", :street => "dahua road").should_not be_valid
  #end

  it "max length of name is 20" do
    Vendor.new(:name => "1" * 21).should_not be_valid
  end

  describe "Scopes" do
    it "of_city works" do
      vendor = Vendor.create(:name => "test", :city => beijing.name, :street => "changan road")
      Vendor.of_city(beijing.name).all.should include(vendor)
    end
  end

end