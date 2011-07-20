require "spec_helper"

describe Revision do
  let(:user) {Factory(:normal_user)}

  it "it works" do
    Revision.new(:content => "sample text", :author_id => user.id).should be_valid
  end

  it "author is mandatory" do
    Revision.new(:content => "sample text").should_not be_valid
  end

  it "content is mandatory" do
    Revision.new(:author_id => user.id).should_not be_valid
  end

  it "max length of content is 140" do
    Revision.new(:content => "1" * 141, :author_id => user.id).should_not be_valid
  end
end