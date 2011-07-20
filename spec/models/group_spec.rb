require 'spec_helper'

describe Group do
  let(:creator) {Factory(:normal_user)}
  let(:tester) {Factory(:tester)}

  it "it works" do
    group = Group.new(:name => "test")
    group.creator_id = creator.id
    group.should be_valid
  end

  it "the name is mandatory" do
    group = Group.new
    group.creator_id = creator.id
    group.should_not be_valid
  end

  it "the max length of name is 30" do
    group = Group.new(:name => "1" * 31)
    group.creator_id = creator.id
    group.should_not be_valid
  end

  it "the max length of description is 200" do
    group =  Group.new(:name => "test", :description => "1" * 201)
    group.creator_id = creator.id
    group.should_not be_valid
  end

  it "the is_creator_by? works" do
    group = Group.new(:name => "test")
    group.creator_id = creator.id
    group.is_creator_by?(creator).should == true
  end

  it "the join! works" do
    group = Group.new(:name => "test")
    group.creator_id = creator.id
    group.join!(tester)
    group.members.should include(tester)
    tester.groups.should include(group)
  end

  it "the quit! works" do
    group = Group.new(:name => "test")
    group.creator_id = creator.id
    group.quit!(creator)
    group.members.should_not include(creator)
    creator.groups.should_not include(group)
  end
end