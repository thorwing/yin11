# encoding utf-8

require 'spec_helper'

describe "bvt" do
  it "Address can be empty" do
    @user = Factory.create(:user, :email => "test@test.de", :login_name => "tester", :password => "123456")
    @user.profile.address.should_not be_new_record
    @user.profile.address.should_not be_nil
  end
end

describe "boundary" do
  it "street's max length is 20" do
    @user = Factory.create(:user, :email => "test@test.de", :login_name => "tester", :password => "123456")
    @user.profile.address.detail = "12345678901234567890"
    @user.profile.address.valid?.should equal true
    @user.profile.address.detail = "123456789012345678901"
    @user.profile.address.valid?.should equal false
  end

  it "place's max length is 20" do
    @user = Factory.create(:user, :email => "test@test.de", :login_name => "tester", :password => "123456")
    @user.profile.address.place = "12345678901234567890"
    @user.profile.address.valid?.should equal true
    @user.profile.address.place = "123456789012345678901"
    @user.profile.address.valid?.should equal false
  end

  it "postcode's max length is 20" do
    @user = Factory.create(:user, :email => "test@test.de", :login_name => "tester", :password => "123456")
    @user.profile.address.postcode = "1234567890"
    @user.profile.address.valid?.should equal true
    @user.profile.address.postcode = "12345678901"
    @user.profile.address.valid?.should equal false
  end

end


