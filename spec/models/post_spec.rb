require File.dirname(__FILE__) + '/../spec_helper'

describe Post do
  it "should not be valid" do
    Post.new.should_not be_valid
  end

  it "title is mandatory" do
    Post.new(:content => "some suggestion").should_not be_valid
  end

  it "content is mandatory" do
    Post.new(:title => "example").should_not be_valid
  end

  it "should be valid" do
    Post.new(:title => "example", :content => "some suggestion").should be_valid
  end
end
