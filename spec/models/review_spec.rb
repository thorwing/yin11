require 'spec_helper'

describe Review do
  it {should validate_presence_of :content}
  it {should ensure_length_of(:content ).
    is_at_most(280) }

  #before { @review = Review.new }
  #subject{ @review }

  #context "get_faults works" do
  #  before {@review.faults = ["bad", "terrible"]}
  #  specify {@review.get_faults.should == "bad | terrible"}
  #end

end