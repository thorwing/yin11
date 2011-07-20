require 'spec_helper'

describe Image do
  it "it works" do
    Image.new.should be_valid
  end

  it "mass assignment works" do
    image = Image.new(:caption => "test", :description => "sample text")
    image.should be_valid
    image.caption.should == "test"
    image.description.should == "sample text"
  end
end
