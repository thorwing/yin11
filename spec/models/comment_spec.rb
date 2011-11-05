require 'spec_helper'

describe Comment do
  it {should validate_presence_of :user}
  it {should validate_presence_of :content}

  it {should ensure_length_of(:content ).
    is_at_most(1000) }

  let(:user) { Factory(:normal_user) }

  it "simply create a comment" do
    Comment.new(:content => "sample text", :user_id => user.id).should be_valid
  end

end