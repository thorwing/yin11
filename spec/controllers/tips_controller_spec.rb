require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe TipsController do

  before(:each) do
    @admin = Factory.create(:user, :login_name => "admin", :email => "admin@yin11.com", :password => "superuser", :role => 9)
    @tester = Factory.create(:user, :login_name => "tester", :email => "tester@yin11.com", :password => "iamtester", :role => 1)
    controller.stub!(:current_user).and_return(@tester)
  end

  def mock_tip(stubs={})
    @mock_tip ||= mock_model(Tip, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all tips as @tips" do
      Tip.stub(:all) { [mock_tip] }
      get :index
      assigns(:tips).should eq([mock_tip])
    end
  end

  describe "GET show" do
    it "assigns the requested tip as @tip" do
      Tip.stub(:find).with("37") { mock_tip }
      get :show, :id => "37"
      assigns(:tip).should be(mock_tip)
    end
  end

  describe "GET new" do
    it "assigns a new tip as @tip" do
      Tip.stub(:new) { mock_tip }
      get :new, :title => "test", :type => "1"
      assigns(:tip).should be(mock_tip)
    end
  end

  describe "GET edit" do
    it "assigns the requested tip as @tip" do
      Tip.stub(:find).with("37") { mock_tip }
      get :edit, :id => "37"
      assigns(:tip).should be(mock_tip)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created tip as @tip" do
        Tip.stub(:new).with({'these' => 'params'}) { mock_tip(:save => true) }
        post :create, :tip => {'these' => 'params'}
        assigns(:tip).should be(mock_tip)
      end

      it "redirects to the created tip" do
        Tip.stub(:new) { mock_tip(:save => true) }
        post :create, :tip => {}
        response.should redirect_to(tip_url(mock_tip))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tip as @tip" do
        Tip.stub(:new).with({'these' => 'params'}) { mock_tip(:save => false) }
        post :create, :tip => {'these' => 'params'}
        assigns(:tip).should be(mock_tip)
      end

      it "re-renders the 'new' template" do
        Tip.stub(:new) { mock_tip(:save => false) }
        post :create, :tip => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tip" do
        Tip.stub(:find).with("37") { mock_tip }
        mock_tip.should_receive(:revise).with(@tester, nil)
        put :update, :id => "37", :tip => {'these' => 'params'}
      end

      it "assigns the requested tip as @tip" do
        Tip.stub(:find) { mock_tip(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:tip).should be(mock_tip)
      end

      it "redirects to the tip" do
        Tip.stub(:find) { mock_tip(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(tip_url(mock_tip))
      end
    end

    describe "with invalid params" do
      it "assigns the tip as @tip" do
        Tip.stub(:find) { mock_tip(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:tip).should be(mock_tip)
      end

      it "re-renders the 'edit' template" do
        Tip.stub(:find) { mock_tip(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested tip" do
      controller.stub!(:current_user).and_return(@admin)

      Tip.stub(:find).with("37") { mock_tip }
      mock_tip.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the tips list" do
      controller.stub!(:current_user).and_return(@admin)

      Tip.stub(:find) { mock_tip }
      delete :destroy, :id => "1"
      response.should redirect_to(tips_url)
    end
  end

end
