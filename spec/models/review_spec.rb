require 'spec_helper'

describe "bvt" do
  it "simpley create a review" do
    review = Factory.create(:review, :title => "test", :content => "1234567890")
    review.should_not be_new_record
    review.should_not be_nil
  end

  it "title can't be nil" do
    review = Factory.build(:review, :content => "1234567890")
    review.valid?.should equal false
  end

  it "content can't be nil" do
    review = Factory.build(:review, :title => "test")
    review.valid?.should equal false
  end
end

describe "boundary" do
  it "title's max length is 20" do
    review = Factory.create(:review, :title => "test", :content => "1234567890")
    review.title = "123456789012345678901"
    review.valid?.should equal false
  end

  it "content's min length is 10" do
    review = Factory.create(:review, :title => "test", :content => "1234567890")
    review.content = "123"
    review.valid?.should equal false
  end

end