require 'spec_helper'

describe Province do
  describe "bvt" do
    it "simply create a province" do
      Province.new(:name => "test", :code => "021", :short_name => "t", :type => "1").should be_valid
    end

    it "name is mandatory" do
      Province.new(:code => "021", :short_name => "t", :type => "1").should_not be_valid
    end

    it "code is mandatory" do
      Province.new(:name => "test", :short_name => "t", :type => "1").should_not be_valid
    end

    it "short_name is not mandatory" do
      Province.new(:name => "test", :code => "021", :type => "1").should be_valid
    end

    it "type is not mandatory" do
      Province.new(:name => "test", :code => "021", :short_name => "t").should be_valid
    end

  end
end