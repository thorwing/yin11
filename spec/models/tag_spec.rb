require 'spec_helper'

describe "bvt" do
  it "simpley create a tag" do
    tag = Factory.create(:tag, :title => "test")
    tag.should_not be_new_record
    tag.should_not be_nil
  end

  it "title can't be nil" do
    tag = Factory.build(:tag)
    tag.valid?.should equal false
  end

end

describe "boundary" do
  it "title's max length is 10" do
    tag = Factory.create(:tag, :title => "test")
    tag.title = "12345678901"
    tag.valid?.should equal false
  end

  it "tags' names are unique" do
    Factory.create(:tag, :title => "test")
    tag = Factory.build(:tag, :title => "test")
    tag.valid?.should equal false
  end

end