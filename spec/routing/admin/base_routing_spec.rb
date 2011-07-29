require "spec_helper"

describe Admin::BaseController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin" }.should route_to(:controller => "admin/base", :action => "index")
    end

    it "recognizes and generates #toggle" do
      { :put => "/admin/base/toggle" }.should route_to(:controller => "admin/base", :action => "toggle")
    end
  end
end
