require 'spec_helper'

describe "bvt" do
  it "simpley create a tip" do
    tip = Factory.create(:tip, :title => "test", :type => 1)
    tip.should_not be_new_record
    tip.should_not be_nil
  end

  it "title can't be nil" do
    tip = Factory.build(:tip)
    tip.valid?.should equal false
  end

end
