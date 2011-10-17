require "spec_helper"

describe Administrator::TipsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/administrator/tips" }.should route_to(:controller => "administrator/tips", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/administrator/tips/1" }.should route_to(:controller => "administrator/tips", :action => "show", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/administrator/tips/1" }.should route_to(:controller => "administrator/tips", :action => "destroy", :id => "1")
    end

  end
end
