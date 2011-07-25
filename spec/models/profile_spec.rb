require 'spec_helper'

describe Profile do
  let(:user) {Factory(:normal_user)}

  it "fields have default values" do
    user.profile.watched_tags.should == []
    user.profile.collected_tip_ids.should == []
    user.profile.receive_mails == true
    user.profile.watched_distance == 2
  end

  it "watched_distance is limited" do
    user.profile.watched_distance = 0
    user.profile.should_not be_valid
    user.profile.watched_distance = 6
    user.profile.should_not be_valid
  end

  it "watch_tags works" do
    user.profile.watch_tags!(["milk", "pork", "milk"])
    user.profile.watched_tags.should == ["milk", "pork"]
  end

end
