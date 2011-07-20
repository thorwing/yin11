require 'spec_helper'

describe Tip do
  let(:user) {Factory(:normal_user)}

  it "simply create a tip" do
    Tip.new(:title => "test", :content => "sample text").should be_valid
  end

  it "title is mandatory" do
    Tip.new(:content => "1"* 10).should_not be_valid
  end

  it "content is mandatory" do
    Tip.new(:title => "test").should_not be_valid
  end

  it "title's max length is 20" do
    Tip.new(:title => "1" * 21,  :content => "1"* 10).should_not be_valid
  end

  it "content's min length is 20" do
    Tip.new(:title => "test",  :content => "1"* 9).should_not be_valid
  end

  it "content's max length is 200" do
    Tip.new(:title => "test",  :content => "1"* 201).should_not be_valid
  end

  it "revise works" do
    tip = Tip.create(:title => "test", :content => "sample text")
    tip.revise(user)
    tip.writer_ids.should include(user.id)
  end

  it "revise works" do
    tip = Tip.create(:title => "test", :content => "1"* 10)
    tip.content = "9" * 10
    tip.revise(user)
    tip.save!
    tip.writer_ids.should include(user.id)
  end

  it "roll_back! works" do
    tip = Tip.create(:title => "test", :content => "1"* 10)
    tip.revise(user)
    tip.save!
    tip.content = "9" * 10
    tip.save!
    tip.content.should == "9" * 10

    tip.roll_back!(tip.revisions.first.id)
    tip.content.should == "1"* 10
  end

end
