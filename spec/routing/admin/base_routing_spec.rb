require "spec_helper"

describe Administrator::BaseController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/administrator" }.should route_to(:controller => "administrator/base", :action => "index")
    end

    it "recognizes and generates #toggle" do
      { :put => "/administrator/base/toggle" }.should route_to(:controller => "administrator/base", :action => "toggle")
    end
  end
end
