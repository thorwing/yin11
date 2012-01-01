require 'spec_helper'

describe Contribution do
  let(:user) { Factory(:normal_user) }

  it "it works" do
    Contribution.new(:user_id => user.id).should be_valid
  end

  it "user is not mandotary" do
    Contribution.new.should be_valid
  end

  it "all field should have default value" do
    c = Contribution.new(:user_id => user.id)
    c.posted_reviews.should == 0
    c.posted_tips.should == 0
    c.edited_tips.should == 0
    c.created_groups.should == 0
    c.total_up_votes.should == 0
    c.total_down_votes.should == 0
  end

end