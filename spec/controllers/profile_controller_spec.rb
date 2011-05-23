require 'spec_helper'

describe ProfileController do

  before(:each) do
    @tester = Factory.create(:user, :login_name => "tester", :email => "tester@yin11.com", :password => "iamtester", :role => 1)
    controller.stub!(:current_user).and_return(@tester)
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

end
