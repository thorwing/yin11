require 'spec_helper'

describe Review do
  before { @review = Review.new }
  subject{ @review }

  describe "title is present" do
    before {@review.title = "test"}
    it {should be_valid}

    context "title is too long" do
      before { @review.title = "1" * 31 }
      it {should_not be_valid}
    end

    context "content is too long" do
      before {@review.content = "1" * 3001 }
      it {should_not be_valid}
    end

    context "get_faults works" do
      before {@review.faults = ["bad", "terrible"]}
      specify {@review.get_faults.should == "bad|terrible"}
    end
  end

  describe "title is not present" do
    it{should_not be_valid}
  end
end