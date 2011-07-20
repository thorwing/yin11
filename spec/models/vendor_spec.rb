require "spec_helper"

describe Vendor do
  let(:beijing) {Factory(:beijing)}

  it "it works" do
    Vendor.new(:name => "test").should be_valid
  end

  it "name is mandatory" do
    Vendor.new.should_not be_valid
  end

  it "name is unique" do
    Vendor.create(:name => "test")
    Vendor.new(:name => "test").should_not be_valid
  end

  it "max length of name is 20" do
    Vendor.new(:name => "1" * 21).should_not be_valid
  end

  describe "Scopes" do
    it "of_city works" do
      vendor = Vendor.create(:name => "test", :city => beijing.name)
      Vendor.of_city(beijing.name).should include(vendor)
    end
  end

end