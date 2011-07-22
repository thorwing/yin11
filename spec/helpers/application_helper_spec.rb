require 'spec_helper'

describe ApplicationHelper do
  it "truncate_content works" do
    truncate_content("1" * 99, 50).size.should == 50
    truncate_content("1" * 30, 50).size.should == 30
  end
end
