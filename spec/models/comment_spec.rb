require 'spec_helper'

describe Comment do
  let(:user) { Factory(:normal_user) }

  it "simply create a comment" do
    Comment.new(:content => "sample text", :user_id => user.id).should be_valid
  end

  it "content is mandatory" do
    Comment.new(:user_id => user.id).should_not be_valid
  end

  it "user is mandatory" do
    Comment.new(:content => "sample text").should_not be_valid
  end

end