require 'spec_helper'

describe "bvt" do
  it "simply create a province" do
    province = Factory.create(:province, :name => "test", :code => "021", :short_name => "t", :type => "1")
    province.should_not be_new_record
    province.should_not be_nil
  end

  it "name is required" do
    province = Factory.build(:province, :code => "021", :short_name => "t", :type => "1")
    province.valid?.should equal false
  end

  it "code is required" do
    province = Factory.build(:province, :name => "test", :short_name => "t", :type => "1")
    province.valid?.should equal false
  end

  it "short_name is required" do
    province = Factory.build(:province, :name => "test", :code => "021", :type => "1")
    province.valid?.should equal false
  end

  it "type is required" do
    province = Factory.build(:province, :name => "test", :code => "021", :short_name => "t")
    province.valid?.should equal false
  end

end