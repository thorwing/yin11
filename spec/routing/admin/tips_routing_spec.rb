require "spec_helper"

describe Admin::TipsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/tips" }.should route_to(:controller => "admin/tips", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/tips/1" }.should route_to(:controller => "admin/tips", :action => "show", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/tips/1" }.should route_to(:controller => "admin/tips", :action => "destroy", :id => "1")
    end

  end
end
