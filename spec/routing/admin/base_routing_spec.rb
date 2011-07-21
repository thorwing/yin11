require "spec_helper"

describe Admin::BaseController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin" }.should route_to(:controller => "admin/base", :action => "index")
    end
  end
end
