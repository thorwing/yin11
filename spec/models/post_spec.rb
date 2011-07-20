require "spec_helper"

describe Post do
  let(:creator) {Factory(:normal_user)}
  let(:group) {Factory(:group, :name => "test", :creator_id => creator.id)}

  it "it works" do
    Post.new(:title => "example", :content => "some suggestion", :group_id => group.id).should be_valid
  end

  it "title is mandatory" do
    Post.new(:content => "some suggestion", :group_id => group.id).should_not be_valid
  end

  it "content is mandatory" do
    Post.new(:title => "example", :group_id => group.id).should_not be_valid
  end

  it "group is mandatory" do
    Post.new(:title => "example", :content => "some suggestion").should_not be_valid
  end

  it "max length of title is 30" do
    Post.new(:title => "1" * 31, :content => "some suggestion", :group_id => group.id).should_not be_valid
  end

  it "max length of content is 1000" do
    Post.new(:title => "example", :content => "1" * 1001, :group_id => group.id).should_not be_valid
  end


end
