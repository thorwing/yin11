require 'spec_helper'

describe Badge do
  it "simpley create a badge" do
    Badge.new(:name => "test", :description => "sample text", :contribution_field => "test_field", :comparator => ">=", :compared_value => 1 ).should be_valid
  end

  it "title is mandatory" do
    Badge.new(:description => "sample text", :contribution_field => "test_field", :comparator => ">=", :compared_value => 1 ).should_not be_valid
  end

  it "description is not mandatory" do
    Badge.new(:name => "test", :contribution_field => "test_field", :comparator => ">=", :compared_value => 1 ).should be_valid
  end

  it "contribution_field is mandatory" do
    Badge.new(:name => "test", :comparator => ">=", :compared_value => 1 ).should_not be_valid
  end

  it "comparator is mandatory" do
    Badge.new(:name => "test", :contribution_field => "test_field", :compared_value => 1 ).should_not be_valid
  end

  it "compared_value is mandatory" do
    Badge.new(:name => "test", :contribution_field => "test_field", :comparator => ">=" ).should_not be_valid
  end
end
