require 'spec_helper'

describe Tip do
  it "simply create a tip" do
    Tip.new(:title => "test", :content => "1"* 10).should be_valid
  end

  it "title is mandatory" do
    Tip.new(:content => "1"* 10).should_not be_valid
  end

  it "content is mandatory" do
    Tip.new(:title => "test").should_not be_valid
  end

  it "title's max length is 20" do
    Tip.new(:title => "1" * 21,  :content => "1"* 10).should_not be_valid
  end

  it "content's min length is 20" do
    Tip.new(:title => "test",  :content => "1"* 9).should_not be_valid
  end

  it "content's max length is 200" do
    Tip.new(:title => "test",  :content => "1"* 201).should_not be_valid
  end

end
