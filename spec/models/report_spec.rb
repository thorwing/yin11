require "spec_helper"

describe Report do
  it "it works" do
    Report.new(:content => "sample text").should be_valid
  end

  it "content is mandatory" do
    Report.new.should_not be_valid
  end

  it "max length of content is 500" do
     Report.new(:content => "1" * 501).should_not be_valid
  end

  it "email format" do
    Report.new(:content => "sample text", :email => "nobodydotcom").should_not be_valid
  end

end