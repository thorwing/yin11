require "spec_helper"

describe Recommendation do
  it "simply create a review" do
      Recommendation.new(:title => "test", :content => "sample").should be_valid
    end

    it "title is mandatory" do
       Recommendation.new(:content => "sample").should_not be_valid
    end

    it "content is not mandatory" do
      Recommendation.new(:title => "test").should be_valid
    end

    it "title's max length is 30" do
      Recommendation.new(:title => "1" * 31, :content => "sample").should_not be_valid
    end

end