require 'spec_helper'

describe ApplicationHelper do
  describe "mark required" do
    it "mark the required fields with *" do
      helper.mark_required(Factory.build(:user), :email).should == "*"
    end
  end
end
