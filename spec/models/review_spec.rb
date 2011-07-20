require 'spec_helper'

describe Review do
  it "it works" do
    Review.new(:title => "test", :content => "sample").should be_valid
  end

  it "title is mandatory" do
     Review.new(:content => "sample").should_not be_valid
  end

  it "content is not mandatory" do
    Review.new(:title => "test").should be_valid
  end

  it "title's max length is 30" do
    Review.new(:title => "1" * 31, :content => "sample").should_not be_valid
  end

  it "content's max length is 3000" do
    Review.new(:title => "test", :content => "1" * 3001).should_not be_valid
  end

  it "get_faults works" do
    review = Review.new(:title => "test", :faults => ["bad", "terrible"])
    review.get_faults.should == "bad|terrible"
  end

end