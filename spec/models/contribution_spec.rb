require 'spec_helper'

describe Contribution do
  let(:user) { Factory(:normal_user) }

  it "works" do
    Contribution.new(:user_id => user.id).should be_valid
  end

  it "user is mandotary" do
    Contribution.new.should_not be_valid
  end

  it "all field should have default value" do
    c = Contribution.new(:user_id => user.id)
    c.posted_recommendation == 0
    c.posted_reviews == 0
    c.posted_articles == 0
    c.posted_tips == 0
    c.edited_tips == 0
    c.created_groups == 0
    c.total_up_votes == 0
    c.total_down_votes == 0
  end

end